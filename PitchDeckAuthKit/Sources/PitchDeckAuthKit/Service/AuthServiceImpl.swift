//
//  AuthServiceImpl.swift
//  PitchDeckAuthKit
//
//  Created by Anton Redkozubov on 14.01.2026.
//

import AppAuth
import PitchDeckCoreKit
import PitchDeckAuthApiKit

@MainActor
public final class AuthServiceImpl: AuthService {
    
    private var authState: OIDAuthState?
    private var _userProfile: UserProfile?
    
    public init() {
        restoreAuthState()
    }
    
    public var userProfile: UserProfile? {
        return _userProfile
    }
    
    // MARK: - Public API
    
    public func authorize(
        loginHint: String?,
        presentationContext: AnyObject
    ) async throws -> (tokens: AuthTokens, profile: UserProfile) {
        let configSnapshot = try await discoverConfiguration()
        
        guard let viewController = presentationContext as? UIViewController else {
            throw AuthError.invalidPresenter
        }
        
        let (tokens, profile) = try await presentAuthorization(
            configSnapshot: configSnapshot,
            loginHint: loginHint,
            presenter: viewController
        )
        
        await saveAuthState()
        return (tokens, profile)
    }
    
    public func refreshTokenIfNeeded() async throws -> AuthTokens {
        guard let authState else {
            throw AuthError.notAuthorized
        }
        
        let idToken = authState.lastTokenResponse?.idToken
        let refreshToken = authState.lastTokenResponse?.refreshToken
        
        return try await withCheckedThrowingContinuation { continuation in
            authState.performAction { accessToken, error, _  in
                if let error {
                    continuation.resume(
                        throwing: AuthError.tokenRefreshFailed(error)
                    )
                    return
                }
                
                guard let accessToken else {
                    continuation.resume(
                        throwing: AuthError.authorizationFailed
                    )
                    return
                }
                
                Task { @MainActor in
                    await self.saveAuthState()
                }
                
                continuation.resume(
                    returning: AuthTokens(
                        accessToken: accessToken,
                        idToken: idToken,
                        refreshToken: refreshToken
                    )
                )
            }
        }
    }
    
    public func logout() async {
        print("[AuthServiceImpl] logout start")
        authState = nil
        _userProfile = nil
        
        await Task.detached {
            await KeychainStorage().remove(forKey: .accessToken)
            await KeychainStorage().remove(forKey: .refreshToken)
            await KeychainStorage().remove(forKey: .authUserId)
        }.value
        
        do {
            await KeychainWrapper.shared.remove(key: "authState")
        }
    }
    
    public var accessToken: String? {
        authState?.lastTokenResponse?.accessToken
    }
    
    public var isAuthorized: Bool {
        // Check both authState and localStorage since authState restores asynchronously
        return authState?.lastTokenResponse?.accessToken != nil
    }
    
    public func isAuthorizedAsync() async -> Bool {
        let accessToken = await KeychainStorage().string(forKey: .accessToken)
        print("[AuthServiceImpl] isAuthorizedAsync: accessToken = \(accessToken != nil ? "PRESENT" : "NIL")")
        let isAuthorized = accessToken != nil && !accessToken!.isEmpty
        print("[AuthServiceImpl] isAuthorizedAsync: result = \(isAuthorized)")
        return isAuthorized
    }
    
    // MARK: - Private helpers
    
    private func parseUserProfile(from idToken: String?) -> UserProfile {
        guard let idToken = idToken else {
            return UserProfile(id: "", email: nil, name: nil)
        }
        
        let parts = idToken.components(separatedBy: ".")
        guard parts.count >= 2,
              let payloadData = base64UrlDecode(parts[1]),
              let json = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any] else {
            return UserProfile(id: "", email: nil, name: nil)
        }
        
        let id = json["sub"] as? String ?? ""
        let email = json["email"] as? String
        let name = json["name"] as? String
        
        return UserProfile(id: id, email: email, name: name)
    }
    
    private func base64UrlDecode(_ base64Url: String) -> Data? {
        var base64 = base64Url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.count)
        if length.truncatingRemainder(dividingBy: 4) != 0 {
            base64.append(String(repeating: "=", count: Int(4 - length.truncatingRemainder(dividingBy: 4))))
        }
        
        return Data(base64Encoded: base64)
    }
}

// MARK: - Private methods

private extension AuthServiceImpl {
    
    func saveAuthState() async {
        guard let authState else { return }
        if let data = try? NSKeyedArchiver.archivedData(
            withRootObject: authState,
            requiringSecureCoding: true
        ) {
            await KeychainWrapper.shared.setData(data, forKey: "authState")
        }
    }
    
    @MainActor
    func restoreAuthState() {
        Task {
            guard let data = await KeychainWrapper.shared.data(forKey: "authState") else { return }
            
            do {
                let state = try NSKeyedUnarchiver.unarchivedObject(
                    ofClass: OIDAuthState.self,
                    from: data
                )
                self.authState = state
            } catch {
                await KeychainWrapper.shared.remove(key: "authState")
            }
        }
    }
    
    private func discoverConfiguration() async throws -> KeycloakConfigSnapshot {
        return try await withCheckedThrowingContinuation { continuation in
            OIDAuthorizationService.discoverConfiguration(forIssuer: KeycloakConfig.issuer) { configuration, error in
                if let configuration {
                    let snapshot = KeycloakConfigSnapshot(
                        authorizationEndpoint: configuration.authorizationEndpoint,
                        tokenEndpoint: configuration.tokenEndpoint
                    )
                    continuation.resume(returning: snapshot)
                } else {
                    continuation.resume(
                        throwing: error ?? AuthError.discoveryFailed
                    )
                }
            }
        }
    }
    
    func presentAuthorization(
        configSnapshot: KeycloakConfigSnapshot,
        loginHint: String?,
        presenter: UIViewController
    ) async throws -> (AuthTokens, UserProfile) {
        let request = OIDAuthorizationRequest(
            configuration: OIDServiceConfiguration(
                authorizationEndpoint: configSnapshot.authorizationEndpoint,
                tokenEndpoint: configSnapshot.tokenEndpoint
            ),
            clientId: KeycloakConfig.clientId,
            clientSecret: KeycloakConfig.clientSecret,
            scopes: [OIDScopeOpenID, OIDScopeProfile, "offline_access"],
            redirectURL: KeycloakConfig.redirectURL,
            responseType: OIDResponseTypeCode,
            additionalParameters: loginHint.map { ["login_hint": $0] }
        )
        return try await withCheckedThrowingContinuation { continuation in
            let flow = OIDAuthState.authState(byPresenting: request, presenting: presenter) { [weak self] authState, error in
                Task { @MainActor [weak self] in
                    guard let self else {
                        continuation.resume(
                            throwing: AuthError.authorizationFailed
                        )
                        return
                    }

                    AppAuthFlowManager.setCurrentAuthorizationFlow(nil)
                    
                    if let authState {
                        self.authState = authState
                        
                        let tokens = AuthTokens(
                            accessToken: authState.lastTokenResponse?.accessToken ?? "",
                            idToken: authState.lastTokenResponse?.idToken,
                            refreshToken: authState.lastTokenResponse?.refreshToken
                        )
                        
                        await Task.detached {
                            print("[AuthServiceImpl] Saving tokens to localStorage...")
                            await KeychainStorage().set(tokens.accessToken, forKey: .accessToken)
                            print("[AuthServiceImpl] Saved accessToken: \(tokens.accessToken.isEmpty ? "EMPTY" : "PRESENT")")
                            if let refreshToken = tokens.refreshToken {
                                await KeychainStorage().set(refreshToken, forKey: .refreshToken)
                                print("[AuthServiceImpl] Saved refreshToken")
                            }
                            if let idToken = tokens.idToken {
                                await KeychainStorage().set(idToken, forKey: .authUserId)
                                print("[AuthServiceImpl] Saved idToken")
                            }
                            print("[AuthServiceImpl] Tokens saved successfully")
                        }.value
                        
                        let profile = self.parseUserProfile(from: authState.lastTokenResponse?.idToken)
                        self._userProfile = profile
                        
                        print("Aboba \(await KeychainStorage().string(forKey: .accessToken))")
                        
                        continuation.resume(returning: (tokens, profile))
                    } else {
                        print("[AuthServiceImpl] AppAuth callback error: \(error?.localizedDescription ?? "unknown")")
                        continuation.resume(
                            throwing: error ?? AuthError.authorizationFailed
                        )
                    }
                }
            }

            AppAuthFlowManager.setCurrentAuthorizationFlow(flow)
        }
    }
}
