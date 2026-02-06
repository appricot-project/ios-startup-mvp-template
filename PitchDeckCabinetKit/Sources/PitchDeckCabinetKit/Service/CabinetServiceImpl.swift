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

public final class CabinetServiceImpl: CabinetService, @unchecked Sendable {
    
    public init() {}
    
    public func getUserProfile() async throws -> UserProfileData {
        guard let accessToken = await KeychainStorage().string(forKey: .accessToken),
              !accessToken.isEmpty else {
            throw CabinetError.noAccessToken
        }
        
        let parts = accessToken.components(separatedBy: ".")
        guard parts.count >= 2,
              let payloadData = base64UrlDecode(parts[1]),
              let json = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any] else {
            throw CabinetError.tokenDecodingFailed
        }
        
        let fullName = (json["name"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let nameParts = fullName.components(separatedBy: " ")

        let firstName = nameParts.first ?? (json["first_name"] as? String ?? "")
        let lastName = nameParts.count > 1 ? nameParts.dropFirst().joined(separator: " ") : (json["last_name"] as? String ?? "")
        let email = json["email"] as? String ?? ""
        
        return UserProfileData(firstName: firstName, lastName: lastName, email: email)
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

public enum CabinetError: LocalizedError {
    case noAccessToken
    case tokenDecodingFailed
    
    public var errorDescription: String? {
        switch self {
        case .noAccessToken:
            return "No access token found"
        case .tokenDecodingFailed:
            return "Failed to decode access token"
        }
    }
}
