//
//  CabinetServiceImpl.swift
//  PitchDeckCabinetKit
//
//  Created by Anton Redkozubov on 03.02.2026.
//

import Foundation
import PitchDeckCoreKit
import PitchDeckCabinetApiKit
import PitchDeckMainApiKit
import JWTDecode

public final class CabinetServiceImpl: CabinetService, @unchecked Sendable {
    
    private let localStorage: LocalStorage
    private let startupService: StartupService
    
    public init(localStorage: LocalStorage, startupService: StartupService) {
        self.localStorage = localStorage
        self.startupService = startupService
    }
    
    public func getUserProfile() async throws -> UserProfile {
        guard let accessToken = try? await localStorage.string(forKey: .accessToken),
              !accessToken.isEmpty else {
            throw CabinetError.noAccessToken
        }
        
        do {
            let jwt = try decode(jwt: accessToken)
            let firstName = jwt.claim(name: "first_name").string ?? ""
            let lastName = jwt.claim(name: "second_name").string ?? ""
            let email = jwt.claim(name: "email").string ?? ""
            
            return UserProfile(firstName: firstName, lastName: lastName, email: email)
        } catch {
            throw CabinetError.tokenDecodingFailed
        }
    }
    
    public func getUserStartups(email: String) async throws -> [StartupItem] {
        do {
            let result = try await startupService.getStartups(title: nil, categoryId: nil, page: 1, pageSize: 100)
            return result.items.filter { startup in
                // TODO: Implement proper filtering by user email when API supports it
                return true
            }
        } catch {
            throw CabinetError.failedToLoadStartups
        }
    }
}

public enum CabinetError: LocalizedError {
    case noAccessToken
    case tokenDecodingFailed
    case failedToLoadStartups
    
    public var errorDescription: String? {
        switch self {
        case .noAccessToken:
            return "No access token found"
        case .tokenDecodingFailed:
            return "Failed to decode access token"
        case .failedToLoadStartups:
            return "Failed to load user startups"
        }
    }
}
