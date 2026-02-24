//
//  UserProfile.swift
//  PitchDeckAuthApiKit
//
//  Created by Anton Redkozubov on 28.01.2026.
//

import Foundation

public struct UserProfile: Sendable {
    public let id: String
    public let email: String?
    public let name: String?
    
    public init(id: String, email: String?, name: String?) {
        self.id = id
        self.email = email
        self.name = name
    }
}
