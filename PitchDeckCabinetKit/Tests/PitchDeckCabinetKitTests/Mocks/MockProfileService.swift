//
//  MockProfileService.swift
//  PitchDeckCabinetKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import Foundation
@testable import PitchDeckAuthApiKit

@MainActor
final class MockProfileService: ProfileService {
    
    // MARK: - Mock data
    
    var mockProfile: ProfileRegistrationRequest?
    
    // MARK: - Error simulation
    
    var shouldFailRegister = false
    var errorToThrow: Error = NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
    
    // MARK: - Call tracking
    
    var registerUserCallCount = 0
    
    // MARK: - Methods
    
    func registerUser(request: ProfileRegistrationRequest) async throws {
        registerUserCallCount += 1
        
        if shouldFailRegister {
            throw errorToThrow
        }
        
        mockProfile = request
    }
    
    // MARK: - Helper methods
    
    func reset() {
        mockProfile = nil
        shouldFailRegister = false
        registerUserCallCount = 0
    }
}
