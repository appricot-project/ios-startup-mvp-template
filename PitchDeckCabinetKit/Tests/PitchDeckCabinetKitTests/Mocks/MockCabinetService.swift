//
//  MockCabinetService.swift
//  PitchDeckCabinetKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import Foundation
@testable import PitchDeckCabinetApiKit

@MainActor
final class MockCabinetService: CabinetService {
    
    // MARK: - Mock data
    
    var mockProfile: UserProfileData?
    
    // MARK: - Error simulation
    
    var shouldFailGetProfile = false
    var errorToThrow: Error = NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
    
    // MARK: - Call tracking
    
    var getUserProfileCallCount = 0
    
    // MARK: - Methods
    
    func getUserProfile() async throws -> UserProfileData {
        getUserProfileCallCount += 1
        
        if shouldFailGetProfile {
            throw errorToThrow
        }
        
        if let mockProfile = mockProfile {
            return mockProfile
        }
        
        return UserProfileData(
            firstName: "Test",
            lastName: "User",
            email: "test@example.com"
        )
    }
    
    // MARK: - Helper methods
    
    func reset() {
        mockProfile = nil
        shouldFailGetProfile = false
        getUserProfileCallCount = 0
    }
}
