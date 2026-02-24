//
//  AuthError.swift
//  PitchDeckAuthApiKit
//
//  Created by Anton Redkozubov on 14.01.2026.
//

import Foundation

public enum AuthError: Error, LocalizedError, Equatable {
    case notAuthorized
    case invalidPresenter
    case discoveryFailed
    case authorizationFailed
    case tokenRefreshFailed(String)
}
