//
//  AppDelegate.swift
//  PitchDeck
//
//  Created by Anton Redkozubov on 18.12.2025.
//

import Foundation
import UIKit
import PitchDeckCoreKit
import PitchDeckAuthKit

@MainActor
class AppDelegate: NSObject, UIApplicationDelegate {
    private let encryptionEngine = EncryptionEngine.sharedInstance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        PitchDeckCoreKit.Config.apiURL = encryptionEngine.encondingData(api: BuildConfiguration.string(forKey: .apiURL), key: BuildConfiguration.Key.apiURL.rawValue)
        PitchDeckCoreKit.Config.strapiURL = encryptionEngine.encondingData(api: BuildConfiguration.string(forKey: .strapiURL), key: BuildConfiguration.Key.strapiURL.rawValue)
        PitchDeckCoreKit.Config.strapiDataURL = encryptionEngine.encondingData(api: BuildConfiguration.string(forKey: .strapiDataURL), key: BuildConfiguration.Key.strapiDataURL.rawValue)
        PitchDeckCoreKit.Config.strapiAuthToken = encryptionEngine.encondingData(api: BuildConfiguration.string(forKey: .strapiAuthToken), key: BuildConfiguration.Key.strapiAuthToken.rawValue)
        PitchDeckCoreKit.Config.keycloakIssuerURL = encryptionEngine.encondingData(api: BuildConfiguration.string(forKey: .keycloakIssuerURL), key: BuildConfiguration.Key.keycloakIssuerURL.rawValue)
        PitchDeckCoreKit.Config.keycloakClientId = encryptionEngine.encondingData(api: BuildConfiguration.string(forKey: .keycloakClientId), key: BuildConfiguration.Key.keycloakClientId.rawValue)
        PitchDeckCoreKit.Config.keycloakClientSecret = encryptionEngine.encondingData(api: BuildConfiguration.string(forKey: .keycloakClientSecret), key: BuildConfiguration.Key.keycloakClientSecret.rawValue)
        
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        AppAuthFlowManager.resumeAuthorizationFlow(with: url)
    }
}
