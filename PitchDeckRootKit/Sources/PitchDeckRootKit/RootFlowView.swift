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

public struct RootFlowView: View {

    @ObservedObject var coordinator: RootCoordinator

    public init(coordinator: RootCoordinator) {
        self.coordinator = coordinator
    }

    public var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            MainFlowView(coordinator: coordinator.main)
                .tabItem { Label("Home", systemImage: "house") }
                .tag(RootCoordinator.Tab.main)
            CabinetFlowView(coordinator: coordinator.cabinet)
                .tabItem { Label("Cabinet", systemImage: "person") }
                .tag(RootCoordinator.Tab.cabinet)
        }
    }
}
