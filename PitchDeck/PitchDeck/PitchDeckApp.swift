//
//  PitchDeckApp.swift
//  PitchDeck
//
//  Created by Anton Redkozubov on 04.12.2025.
//

import SwiftUI
import PitchDeckNavigationKit
import PitchDeckRootKit

@main
struct PitchDeckApp: App {
    
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            RootFlowView(coordinator: appCoordinator.rootCoordinator)
        }
    }
}
