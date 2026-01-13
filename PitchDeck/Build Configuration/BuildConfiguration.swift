//
//  BuildConfiguration.swift
//  PitchDeck
//
//  Created by Anton Redkozubov on 12.12.2025.
//

import Foundation

public struct BuildConfiguration {

    enum BaseURL {
        static let apiURL = "API_URL"
    }

    enum Key: String {
        case apiURL = "API_URL"
        case apiSecretKey = "SL_API_SECRET_KEY"
        case strapiURL = "STRAPI_URL"
        case strapiAuthToken = "STRAPI_AUTH_TOKEN"
    }

    static let apiURL: String = {
        guard let baseUrl = Bundle.main.object(
            forInfoDictionaryKey: BaseURL.apiURL
        ) as? String else {
            fatalError("API_URL not found")
        }
        return baseUrl
    }()

    static func string(forKey key: Key) -> String {
        guard let key = Bundle.main.object(
            forInfoDictionaryKey: key.rawValue
        ) as? String else {
            fatalError("Invalid value or undefined key \(key.rawValue)")
        }
        return key
    }

    static func url(forKey key: Key) -> String {
        guard let key = Bundle.main.object(
            forInfoDictionaryKey: key.rawValue
        ) as? String else {
            fatalError("Invalid value or undefined key \(key.rawValue)")
        }
        return "https://" + key
    }

    static func bool(forKey key: Key) -> Bool {
        guard let key = Bundle.main.object(
            forInfoDictionaryKey: key.rawValue
        ) as? NSString else {
            fatalError("Invalid value or undefined key \(key.rawValue)")
        }
        return key.boolValue
    }
}
