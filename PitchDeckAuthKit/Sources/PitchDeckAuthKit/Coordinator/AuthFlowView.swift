//
//  AuthFlowView.swift
//  PitchDeckAuthKit
//
//  Created by Anatoly Nevmerzhitsky on 10.12.2025.
//

import SwiftUI
import Foundation
import PitchDeckNavigationApiKit

public struct AuthFlowView: View {
    
    @ObservedObject var coordinator: AuthCoordinator
    @StateObject private var viewModel: AuthMainViewModel
    
    public init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
        _viewModel = StateObject(
            wrappedValue: AuthMainViewModel(authService: coordinator.authService)
        )
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            AuthMainScreen(viewModel: viewModel, onSelectConfirmation: { email in
                coordinator.push(.confirmation(email))
            })
            .navigationDestination(for: AuthRoute.self) { route in
                coordinator.build(route: route)
            }
        }
    }
}
