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
    case zendeskIdentToken
    case deviceToken
    case login
    case password
    case apiUser
    case apiPassword
    case deviceUUID
    case apiSecretKey
    case isTutorialPast
    case isLoginPast
    case isPinPast
    case securityCode
    case isFaceIdEnabled
    case isTouchIdEnabled
    case lastActivityDate
    case userAvatar
    case userId
    case isNotFirstEntry
    case currentTheme
    case promptedLastVersion
    case areLoadedLibraries
    case isProfileIncompleteAlertShowed
    case isVerifyingDataAlertShowed
    case isFailVerifyDataAlertShowed
    case custom(String)
    case testKey
    case appsFlyerUID
    case promocode
    
    // MARK: - Public properties
    
    public var rawValue: RawValue {
        switch self {
        case .login: return addBundlePrefixForKey("login")
        case .password: return addBundlePrefixForKey("password")
        case .accessToken: return addBundlePrefixForKey("accessToken")
        case .refreshToken: return addBundlePrefixForKey("refreshToken")
        case .zendeskIdentToken: return addBundlePrefixForKey("zendeskIdentToken")
        case .deviceToken: return addBundlePrefixForKey("deviceToken")
        case .apiUser: return addBundlePrefixForKey("apiUser")
        case .apiPassword: return addBundlePrefixForKey("apiPassword")
        case .deviceUUID: return addBundlePrefixForKey("deviceUUID")
        case .apiSecretKey: return addBundlePrefixForKey("apiSecretKey")
        case .isTutorialPast: return addBundlePrefixForKey("isTutorialPast")
        case .isLoginPast: return addBundlePrefixForKey("isLoginPast")
        case .isPinPast: return addBundlePrefixForKey("isPinPast")
        case .securityCode: return addBundlePrefixForKey("securityCode")
        case .isFaceIdEnabled: return addBundlePrefixForKey("isFaceIdEnabled")
        case .isTouchIdEnabled: return addBundlePrefixForKey("isTouchIdEnabled")
        case .lastActivityDate: return addBundlePrefixForKey("lastActivityDate")
        case .userAvatar: return addBundlePrefixForKey("userAvatar")
        case .userId: return addBundlePrefixForKey("userId")
        case .isNotFirstEntry: return addBundlePrefixForKey("isFirstEntry")
        case .currentTheme: return addBundlePrefixForKey("currentTheme")
        case .promptedLastVersion: return addBundlePrefixForKey("promptedLastVersion")
        case .custom(let key): return addBundlePrefixForKey(key)
        case .areLoadedLibraries: return addBundlePrefixForKey("areLoadedLibraries")
        case .isProfileIncompleteAlertShowed: return addBundlePrefixForKey("isProfileIncompleteAlertShowed")
        case .isVerifyingDataAlertShowed: return addBundlePrefixForKey("isVerifyingDataAlertShowed")
        case .isFailVerifyDataAlertShowed: return addBundlePrefixForKey("isFailVerifyDataAlertShowed")
        case .testKey: return addBundlePrefixForKey("testKey")
        case .appsFlyerUID: return addBundlePrefixForKey("appsFlyerUID")
        case .promocode: return addBundlePrefixForKey("promocode")
        }
    }
    
    // MARK: - Private methods
    
    private func addBundlePrefixForKey(_ key: String) -> String {
        return Bundle.main.bundleIdentifier! + "." + key
    }
}

