//
//  AuthService.swift
//  PitchDeckAuthApiKit
//
//  Created by Anton Redkozubov on 14.01.2026.
//

import Foundation

@MainActor
public protocol AuthService: Sendable {
    var accessToken: String? { get }
    var isAuthorized: Bool { get }

    func authorize(
        loginHint: String?,
        presentationContext: AnyObject
    ) async throws -> AuthTokens

    func refreshTokenIfNeeded() async throws -> AuthTokens
    func logout() async
}
