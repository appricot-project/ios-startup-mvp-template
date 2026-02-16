//
//  RootCoordinator.swift
//  PitchDeckRootKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import SwiftUI
import Combine
import PitchDeckMainKit
import PitchDeckCabinetKit
import PitchDeckAuthKit
import PitchDeckCoreKit

@MainActor
public final class RootCoordinator: ObservableObject {

    @Published public var selectedTab: Tab = .main
    @Published public var logoutTrigger: UUID = UUID()
    @Published public var currentUserEmail: String = ""

    public enum Tab {
        case main
        case cabinet
    }
        
    public init() { 
        setupCabinetCoordinator()
    }

    public lazy var main: MainCoordinator = {
        MainCoordinator(service: StartupServiceImpl(), currentUserEmail: currentUserEmail)
    }()
    
    public func updateMainCoordinatorEmail() {
        let newMainCoordinator = MainCoordinator(service: StartupServiceImpl(), currentUserEmail: currentUserEmail)
        main = newMainCoordinator
    }
    public lazy var cabinet = CabinetCoordinator(
        cabinetService: CabinetServiceImpl(),
        startupService: StartupServiceImpl(),
        authService: AuthServiceImpl(),
        startupDetailNavigationService: StartupDetailNavigationServiceImpl(startupService: StartupServiceImpl()),
        startupEditNavigationService: StartupEditNavigationServiceImpl(startupService: StartupServiceImpl())
    )
    public let auth = AuthCoordinator(authService: AuthServiceImpl())
    
    // MARK: - Private methods
    
    private func setupCabinetCoordinator() {
        cabinet.onLogout = { [weak self] in
            self?.logoutTrigger = UUID()
            self?.selectedTab = .main
            self?.clearUserEmail()
        }
        
        cabinet.onStartupCreated = { [weak self] in
            self?.main.viewModel.send(event: .onRefresh)
        }
    }
    
    private func clearUserEmail() {
        currentUserEmail = ""
        Task { @MainActor in
            do {
                try await KeychainStorage().remove(forKey: .userEmail)
            } catch {
                print("Failed to remove email from keychain: \(error)")
            }
        }
    }
    
    private func handleLogout() {
        selectedTab = .main
    }
}
