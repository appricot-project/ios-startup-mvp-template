//
//  LocalStorageKey.swift
//  PitchDeckCoreKit
//
//  Created by Anatoly Nevmerzhitsky on 08.12.2025.
//

import Foundation

public enum LocalStorageKey {
    public typealias RawValue = String
    case accessToken
    case refreshToken
    case login
    case password
    case apiUser
    case apiPassword
    case apiSecretKey
    case isLoginPast
    case isNotFirstEntry
    case custom(String)
    
    // MARK: - Public properties
    
    public var rawValue: RawValue {
        switch self {
        case .login: return addBundlePrefixForKey("login")
        case .password: return addBundlePrefixForKey("password")
        case .accessToken: return addBundlePrefixForKey("accessToken")
        case .refreshToken: return addBundlePrefixForKey("refreshToken")
        case .apiUser: return addBundlePrefixForKey("apiUser")
        case .apiPassword: return addBundlePrefixForKey("apiPassword")
        case .apiSecretKey: return addBundlePrefixForKey("apiSecretKey")
        case .isLoginPast: return addBundlePrefixForKey("isLoginPast")
        case .isNotFirstEntry: return addBundlePrefixForKey("isFirstEntry")
        case .custom(let key): return addBundlePrefixForKey(key)
        }
    }
    
    // MARK: - Private methods
    
    private func addBundlePrefixForKey(_ key: String) -> String {
        return Bundle.main.bundleIdentifier! + "." + key
    }
}

