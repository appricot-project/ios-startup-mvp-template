//
//  ProfileService.swift
//  PitchDeckAuthApiKit
//
//  Created by Anton Redkozubov on 21.01.2026.
//

import Foundation

@MainActor
public protocol ProfileService: Sendable {
    func registerUser(request: ProfileRegistrationRequest) async throws
}
