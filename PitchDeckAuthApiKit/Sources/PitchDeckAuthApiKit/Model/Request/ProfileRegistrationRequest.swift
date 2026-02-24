//
//  ProfileRegistrationRequest.swift
//  PitchDeckAuthApiKit
//
//  Created by Anton Redkozubov on 28.01.2026.
//

import Foundation

public struct ProfileRegistrationRequest: Sendable {
    public let email: String
    public let firstName: String
    public let lastName: String
    
    public init(email: String, firstName: String, lastName: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
}
