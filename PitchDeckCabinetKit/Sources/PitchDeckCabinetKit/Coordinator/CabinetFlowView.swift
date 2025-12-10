//
//  CabinetFlowView.swift
//  PitchDeckCabinetKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import Foundation
import SwiftUI
import PitchDeckNavigationApiKit

public struct CabinetFlowView: View {
    
    @ObservedObject var coordinator: CabinetCoordinator
    
    public init(coordinator: CabinetCoordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            CabinetScreen(onSettingsTap: {
                coordinator.push(.accountSettings)
            })
            .navigationDestination(for: CabinetRoute.self) { route in
                coordinator.build(route: route)
            }
        }
    }
}
