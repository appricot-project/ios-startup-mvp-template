//
//  ProfileServiceImpl.swift
//  PitchDeckAuthKit
//
//  Created by Anton Redkozubov on 21.01.2026.
//

import Foundation
import PitchDeckCoreKit
import PitchDeckAuthApiKit
import Alamofire

@MainActor
public final class ProfileServiceImpl: ProfileService, @unchecked Sendable {
    
    private let httpClient: HttpClient
    
    public init() {
        self.httpClient = HttpClient(baseUrl: Config.apiURL ?? "")
    }
    
    public func registerUser(request: ProfileRegistrationRequest) async throws {
        let parameters: Parameters = [
            "email": request.email,
            "firstName": request.firstName,
            "lastName": request.lastName
        ]
        
        let headers: HTTPHeaders = [
            "accept": "text/plain",
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest"
        ]
        
        do {
            let _: EmptyResponse = try await httpClient.request(
                path: "/api/keycloak/user",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
            )
        } catch {
            throw BaseServiceError.registrationFailed(error.localizedDescription)
        }
    }
}

// MARK: - Supporting Types

private struct EmptyResponse: Decodable { }
