//
//  File.swift
//  PitchDeckAuthKit
//
//  Created by Anatoly Nevmerzhitsky on 10.12.2025.
//

import SwiftUI
import Foundation
import PitchDeckNavigationApiKit

public struct AuthFlowView: View {
    
    @ObservedObject var coordinator: AuthCoordinator
    
    public init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            AuthMainScreen(onSelectConfirmation: { email in
                coordinator.push(.confirmation(email))
            })
            .navigationDestination(for: AuthRoute.self) { route in
                coordinator.build(route: route)
            }
        }
    }
}
