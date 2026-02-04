//
//  UserProfile.swift
//  PitchDeckCabinetApiKit
//
//  Created by Anton Redkozubov on 03.02.2026.
//

import Foundation

public struct UserProfile: Sendable {
    public let firstName: String
    public let lastName: String
    public let email: String
    
    public init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
