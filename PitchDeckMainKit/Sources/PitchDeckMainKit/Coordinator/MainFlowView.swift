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
    private let service: StartupService
    
    public init(coordinator: MainCoordinator, service: StartupService) {
        self.coordinator = coordinator
        self.service = service
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            MainScreen(viewModel: StartupListViewModel(service: service))
//            MainScreen(onSelectDetail: { id in
//                coordinator.push(.details(id: id))
//            })
            .navigationDestination(for: MainRoute.self) { route in
                coordinator.build(route: route)
            }
        }
    }
}
