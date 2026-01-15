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
    
    private let keychain: KeychainWrapper
    
    public init(keychain: KeychainWrapper = .shared) {
        self.keychain = keychain
        restoreAuthState()
    }
    
    // MARK: - Public API
    
    public func authorize(
        loginHint: String?,
        presentationContext: AnyObject
    ) async throws -> AuthTokens {
        
        let configSnapshot = try await discoverConfiguration()
        
        guard let viewController = presentationContext as? UIViewController else {
            throw AuthError.invalidPresenter
        }
        
        let tokens = try await presentAuthorization(
            configSnapshot: configSnapshot,
            loginHint: loginHint,
            presenter: viewController
        )
        
        await saveAuthState()
        
        return tokens
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
        authState = nil
        await keychain.remove(key: "authState")
    }
    
    public var accessToken: String? {
        authState?.lastTokenResponse?.accessToken
    }
    
    public var isAuthorized: Bool {
        accessToken != nil
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
    
    func discoverConfiguration() async throws -> KeycloakConfigSnapshot {
        try await withCheckedThrowingContinuation { continuation in
            OIDAuthorizationService.discoverConfiguration(
                forIssuer: KeycloakConfig.issuer
            ) { config, error in
                if let config {
                    let snapshot = KeycloakConfigSnapshot(
                        authorizationEndpoint: config.authorizationEndpoint,
                        tokenEndpoint: config.tokenEndpoint
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
    ) async throws -> AuthTokens {
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
        
        print("qweqwe", request.redirectURL!.absoluteString)
        
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
                        continuation.resume(returning: tokens)
                    } else {
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
