//
//  RootCoordinator.swift
//  PitchDeckRootKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import SwiftUI
import PitchDeckMainKit
import PitchDeckCabinetKit
import PitchDeckAuthKit
import PitchDeckCoreKit

@MainActor
public final class RootCoordinator: ObservableObject {

    @Published public var selectedTab: Tab = .main
    @Published public var logoutTrigger: UUID = UUID()

    public enum Tab {
        case main
        case cabinet
    }
        
    public init() { 
        setupCabinetCoordinator()
    }

    public let main = MainCoordinator(service: StartupServiceImpl())
    public lazy var cabinet = CabinetCoordinator(
        cabinetService: CabinetServiceImpl(),
        startupService: StartupServiceImpl(),
        authService: AuthServiceImpl()
    )
    public let auth = AuthCoordinator(authService: AuthServiceImpl())
    
    // MARK: - Private methods
    
    private func setupCabinetCoordinator() {
        cabinet.onLogout = { [weak self] in
            self?.logoutTrigger = UUID()
            self?.selectedTab = .main
        }
    }
    
    private func handleLogout() {
        selectedTab = .main
    }
}
