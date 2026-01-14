//
//  KeycloakConfig.swift
//  PitchDeckAuthKit
//
//  Created by Anton Redkozubov on 14.01.2026.
//

import Foundation

public struct KeycloakConfigSnapshot {
    public let authorizationEndpoint: URL
    public let tokenEndpoint: URL
}

enum KeycloakConfig {
    static let issuer = URL(
        string: "http://id.appricot.ru/realms/foundation"
    )!

    static let clientId = "PitchDeck_App"

    static let redirectURL = URL(
        string: "pitch://auth/callback"
    )!
}
