//
//  AuthTokens.swift
//  PitchDeckAuthApiKit
//
//  Created by Anton Redkozubov on 14.01.2026.
//

import Foundation

public struct AuthTokens {
    public let accessToken: String
    public let idToken: String?
    public let refreshToken: String?

    public init(
        accessToken: String,
        idToken: String?,
        refreshToken: String?
    ) {
        self.accessToken = accessToken
        self.idToken = idToken
        self.refreshToken = refreshToken
    }
}

public struct UserProfile {
    public let id: String
    public let email: String?
    public let name: String?
    
    public init(id: String, email: String?, name: String?) {
        self.id = id
        self.email = email
        self.name = name
    }
}
