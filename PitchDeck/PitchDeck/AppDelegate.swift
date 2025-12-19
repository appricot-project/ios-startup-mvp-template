//
//  AppDelegate.swift
//  PitchDeck
//
//  Created by Anton Redkozubov on 18.12.2025.
//

import Foundation
import UIKit
import PitchDeckCoreKit

class AppDelegate: NSObject, UIApplicationDelegate {
    private let encryptionEngine = EncryptionEngine.sharedInstance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        PitchDeckCoreKit.Config.strapiURL = encryptionEngine.encondingData(api: BuildConfiguration.string(forKey: .strapiURL), key: BuildConfiguration.Key.strapiURL.rawValue)
        PitchDeckCoreKit.Config.strapiAuthToken = encryptionEngine.encondingData(api: BuildConfiguration.string(forKey: .strapiAuthToken), key: BuildConfiguration.Key.strapiAuthToken.rawValue)
        return true
    }
}
