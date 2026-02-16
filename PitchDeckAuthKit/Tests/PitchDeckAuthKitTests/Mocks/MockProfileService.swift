//
//  MockProfileService.swift
//  PitchDeckAuthKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import Foundation
@testable import PitchDeckAuthApiKit

@MainActor
final class MockProfileService: ProfileService {
    
    // MARK: - Mock data
    
    var mockProfile: UserProfile?
    
    // MARK: - Error simulation
    
    var shouldSucceed = true
    var errorToThrow: Error = NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
    
    // MARK: - Call tracking
    
    var registerUserCallCount = 0
    var lastRequest: ProfileRegistrationRequest?
    
    // MARK: - Methods
    
    func registerUser(request: ProfileRegistrationRequest) async throws {
        registerUserCallCount += 1
        lastRequest = request
        
        if !shouldSucceed {
            throw errorToThrow
        }
        
        mockProfile = UserProfile(
            id: "user-123",
            email: request.email,
            name: request.firstName + request.lastName,
        )
    }
    
    // MARK: - Helper methods
    
    func reset() {
        mockProfile = nil
        shouldSucceed = true
        registerUserCallCount = 0
        lastRequest = nil
    }
}
