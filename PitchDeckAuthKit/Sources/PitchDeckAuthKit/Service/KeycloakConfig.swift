//
//  KeycloakConfig.swift
//  PitchDeckAuthKit
//
//  Created by Anton Redkozubov on 14.01.2026.
//

import Foundation
import PitchDeckCoreKit

public struct KeycloakConfigSnapshot {
    public let authorizationEndpoint: URL
    public let tokenEndpoint: URL
}

@MainActor
enum KeycloakConfig {
    static let issuer = URL(
        string: Config.keycloakIssuerURL ?? ""
    )!
    static let clientId = Config.keycloakClientId ?? ""
    static let clientSecret = Config.keycloakClientSecret ?? ""
    static let redirectURL = URL(
        string: "pitchdeck://auth/callback"
    )!
}
