//
//  RootFlowView.swift
//  PitchDeckRootKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import Foundation
import SwiftUI
import PitchDeckMainKit
import PitchDeckCabinetKit
import PitchDeckAuthKit
import PitchDeckCoreKit

public struct RootFlowView: View {

    @ObservedObject var coordinator: RootCoordinator
    @State private var isAuthPresented: Bool = false
    @State private var previousTab: RootCoordinator.Tab = .main
    @State private var refreshTrigger: UUID = UUID()
    
    public init(coordinator: RootCoordinator) {
        self.coordinator = coordinator
    }

    public var body: some View {
        TabView(selection: Binding(
            get: { coordinator.selectedTab },
            set: { newValue in
                if newValue == .cabinet {
                    let currentTab = coordinator.selectedTab
                    previousTab = currentTab
                    coordinator.selectedTab = currentTab

                    Task { @MainActor in
                        let isAuthorized = await coordinator.auth.authService.isAuthorizedAsync()
                        if !isAuthorized {
                            isAuthPresented = true
                        } else {
                            coordinator.selectedTab = newValue
                        }
                    }
                } else {
                    previousTab = coordinator.selectedTab
                    coordinator.selectedTab = newValue
                }
            }
        )) {
            MainFlowView(coordinator: coordinator.main)
                .tabItem { Label("Startups", systemImage: "house") }
                .tag(RootCoordinator.Tab.main)
            CabinetFlowView(coordinator: coordinator.cabinet)
                .tabItem { Label("Cabinet", systemImage: "person") }
                .tag(RootCoordinator.Tab.cabinet)
        }
        .id(refreshTrigger)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("UserDidLogout"))) { _ in
            coordinator.selectedTab = .main
        }
        .onReceive(coordinator.$currentUserEmail) { email in
            coordinator.main.currentUserEmail = email
        }
        .fullScreenCover(isPresented: $isAuthPresented) {
            AuthFlowView(
                coordinator: coordinator.auth,
                onClose: {
                    isAuthPresented = false
                    refreshTrigger = UUID()
                    coordinator.selectedTab = previousTab
                },
                onAuthorized: {
                    isAuthPresented = false
                    refreshTrigger = UUID()
                    coordinator.selectedTab = .cabinet
                }
            )
            .interactiveDismissDisabled(true)
        }
    }
}
