//
//  MainFlowView.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import Foundation
import SwiftUI
import PitchDeckMainApiKit
import PitchDeckNavigationApiKit

public struct MainFlowView: View {
    
    @ObservedObject var coordinator: MainCoordinator
    
    public init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            StartupsView(
                viewModel: coordinator.viewModel,
                onStartupSelected: { documentId in
                    coordinator.push(.details(documentId: documentId))
                }
            )
            .navigationDestination(for: MainRoute.self) { route in
                coordinator.build(route: route)
            }
            .navigationBarBackButtonHidden(false)
        }
    }
}
