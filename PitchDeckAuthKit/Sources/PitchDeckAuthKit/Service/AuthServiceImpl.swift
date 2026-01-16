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
    
    private let keychain: KeychainWrapper
    
    public init(keychain: KeychainWrapper = .shared) {
        self.keychain = keychain
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
        print("[AuthServiceImpl] authorize start")
        let configSnapshot = try await discoverConfiguration()
        print("[AuthServiceImpl] discovery success: \(configSnapshot.authorizationEndpoint), token: \(configSnapshot.tokenEndpoint)")
        
        guard let viewController = presentationContext as? UIViewController else {
            throw AuthError.invalidPresenter
        }
        
        let (tokens, profile) = try await presentAuthorization(
            configSnapshot: configSnapshot,
            loginHint: loginHint,
            presenter: viewController
        )
        
        await saveAuthState()
        print("[AuthServiceImpl] authorize success, tokens and profile saved")
        return (tokens, profile)
    }
    
    public func refreshTokenIfNeeded() async throws -> AuthTokens {
        print("[AuthServiceImpl] refreshTokenIfNeeded start")
        guard let authState else {
            print("[AuthServiceImpl] no authState, throwing notAuthorized")
            throw AuthError.notAuthorized
        }
        
        let idToken = authState.lastTokenResponse?.idToken
        let refreshToken = authState.lastTokenResponse?.refreshToken
        print("[AuthServiceImpl] existing tokens: idToken=\(idToken != nil ? "present" : "nil"), refreshToken=\(refreshToken != nil ? "present" : "nil")")
        
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
        do {
            await keychain.remove(key: "authState")
            print("[AuthServiceImpl] logout success, keychain cleared")
        } catch {
            print("[AuthServiceImpl] logout keychain error: \(error)")
        }
    }
    
    public var accessToken: String? {
        authState?.lastTokenResponse?.accessToken
    }
    
    public var isAuthorized: Bool {
        accessToken != nil
    }
    
    // MARK: - Private helpers
    
    private func parseUserProfile(from idToken: String?) -> UserProfile {
        guard let idToken = idToken else {
            print("[AuthServiceImpl] parseUserProfile: idToken is nil")
            return UserProfile(id: "", email: nil, name: nil)
        }
        
        let parts = idToken.components(separatedBy: ".")
        guard parts.count >= 2,
              let payloadData = base64UrlDecode(parts[1]),
              let json = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any] else {
            print("[AuthServiceImpl] parseUserProfile: failed to decode JWT payload")
            return UserProfile(id: "", email: nil, name: nil)
        }
        
        let id = json["sub"] as? String ?? ""
        let email = json["email"] as? String
        let name = json["name"] as? String
        
        print("[AuthServiceImpl] parseUserProfile: id=\(id), email=\(email ?? "nil"), name=\(name ?? "nil")")
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
            await keychain.set(data, for: "authState")
        }
    }
    
    @MainActor
    func restoreAuthState() {
        Task {
            guard let data = await keychain.data(forKey: "authState") else { return }
            
            do {
                let state = try NSKeyedUnarchiver.unarchivedObject(
                    ofClass: OIDAuthState.self,
                    from: data
                )
                self.authState = state
            } catch {
                await keychain.remove("authState")
            }
        }
    }
    
    private func discoverConfiguration() async throws -> KeycloakConfigSnapshot {
        print("[AuthServiceImpl] discoverConfiguration start for issuer: \(KeycloakConfig.issuer)")
        return try await withCheckedThrowingContinuation { continuation in
            OIDAuthorizationService.discoverConfiguration(forIssuer: KeycloakConfig.issuer) { configuration, error in
                if let configuration {
                    let snapshot = KeycloakConfigSnapshot(
                        authorizationEndpoint: configuration.authorizationEndpoint,
                        tokenEndpoint: configuration.tokenEndpoint
                    )
                    print("[AuthServiceImpl] discoverConfiguration success")
                    continuation.resume(returning: snapshot)
                } else {
                    print("[AuthServiceImpl] discoverConfiguration failed: \(error?.localizedDescription ?? "unknown")")
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
        print("[AuthServiceImpl] presentAuthorization start")
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
        print("[AuthServiceImpl] OIDAuthorizationRequest created: redirectURL=\(request.redirectURL?.absoluteString ?? "nil"), clientId=\(request.clientID)")
        
        return try await withCheckedThrowingContinuation { continuation in
            let flow = OIDAuthState.authState(byPresenting: request, presenting: presenter) { [weak self] authState, error in
                Task { @MainActor [weak self] in
                    guard let self else {
                        print("[AuthServiceImpl] AppAuth callback: self is nil")
                        continuation.resume(
                            throwing: AuthError.authorizationFailed
                        )
                        return
                    }

                    AppAuthFlowManager.setCurrentAuthorizationFlow(nil)
                    
                    if let authState {
                        print("[AuthServiceImpl] AppAuth callback success")
                        self.authState = authState
                        
                        let tokens = AuthTokens(
                            accessToken: authState.lastTokenResponse?.accessToken ?? "",
                            idToken: authState.lastTokenResponse?.idToken,
                            refreshToken: authState.lastTokenResponse?.refreshToken
                        )
                        
                        let profile = self.parseUserProfile(from: authState.lastTokenResponse?.idToken)
                        self._userProfile = profile
                        
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
