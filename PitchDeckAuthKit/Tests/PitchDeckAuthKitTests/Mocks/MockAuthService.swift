//
//  MockAuthService.swift
//  PitchDeckAuthKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import Foundation
@testable import PitchDeckAuthApiKit

@MainActor
final class MockAuthService: AuthService {
    
    // MARK: - Published properties
    
    @Published public var accessToken: String?
    @Published public var isAuthorized: Bool = false
    @Published public var userProfile: UserProfile?
    
    // MARK: - Mock data
    
    var mockTokens: AuthTokens?
    var mockProfile: UserProfile?
    
    // MARK: - Error simulation
    
    var shouldSucceed = true
    var errorToThrow: Error = NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
    
    // MARK: - Call tracking
    
    var authorizeCallCount = 0
    var refreshTokenCallCount = 0
    var logoutCallCount = 0
    var isAuthorizedAsyncCallCount = 0
    
    var lastLoginHint: String?
    var lastPresentationContext: AnyObject?
    
    // MARK: - Methods
    
    func authorize(
        loginHint: String?,
        presentationContext: AnyObject
    ) async throws -> (tokens: AuthTokens, profile: UserProfile) {
        authorizeCallCount += 1
        lastLoginHint = loginHint
        lastPresentationContext = presentationContext
        
        if !shouldSucceed {
            throw errorToThrow
        }
        
        let tokens = mockTokens ?? AuthTokens(
            accessToken: "mock-access-token",
            idToken: "mock-id-token", 
            refreshToken: "mock-refresh-token"
        )
        
        let profile = mockProfile ?? UserProfile(
            id: "user-123",
            email: "test@example.com",
            name: "Test User"
        )
        
        self.accessToken = tokens.accessToken
        self.isAuthorized = true
        self.userProfile = profile
        
        return (tokens: tokens, profile: profile)
    }
    
    func refreshTokenIfNeeded() async throws -> AuthTokens {
        refreshTokenCallCount += 1
        
        if !shouldSucceed {
            throw errorToThrow
        }
        
        let tokens = mockTokens ?? AuthTokens(
            accessToken: "mock-access-token",
            idToken: "mock-id-token",
            refreshToken: "mock-refresh-token"
        )
        
        self.accessToken = tokens.accessToken
        
        return tokens
    }
    
    func logout() async {
        logoutCallCount += 1
        
        self.accessToken = nil
        self.isAuthorized = false
        self.userProfile = nil
    }
    
    func isAuthorizedAsync() async -> Bool {
        isAuthorizedAsyncCallCount += 1
        return isAuthorized
    }
    
    // MARK: - Helper methods
    
    func reset() {
        accessToken = nil
        isAuthorized = false
        userProfile = nil
        
        mockTokens = nil
        mockProfile = nil
        
        shouldSucceed = true
        
        authorizeCallCount = 0
        refreshTokenCallCount = 0
        logoutCallCount = 0
        isAuthorizedAsyncCallCount = 0
        
        lastLoginHint = nil
        lastPresentationContext = nil
    }
}
