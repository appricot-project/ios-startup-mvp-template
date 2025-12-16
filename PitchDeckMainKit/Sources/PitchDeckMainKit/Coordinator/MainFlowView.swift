//
//  MainFlowView.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import Foundation
import SwiftUI
import PitchDeckNavigationApiKit

public struct MainFlowView: View {
    
    @ObservedObject var coordinator: MainCoordinator
    
    public init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            MainScreen(viewModel: StartupListViewModel())
//            MainScreen(onSelectDetail: { id in
//                coordinator.push(.details(id: id))
//            })
            .navigationDestination(for: MainRoute.self) { route in
                coordinator.build(route: route)
            }
        }
    }
}
