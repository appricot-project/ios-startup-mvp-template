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
    private let onClose: () -> Void
    private let onAuthorized: () -> Void
    
    public init(
        coordinator: AuthCoordinator,
        onClose: @escaping () -> Void,
        onAuthorized: @escaping () -> Void
    ) {
        self.coordinator = coordinator
        self.onClose = onClose
        self.onAuthorized = onAuthorized
        
        // Пробрасываем колбэк успешной авторизации из координатора наружу
        self.coordinator.onAuthorizationCompleted = onAuthorized
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            AuthStartScreen(
                    onLogin: {
                        coordinator.push(.login(prefillEmail: nil))
                    },
                    onRegistration: {
                        coordinator.push(.registration)
                    }
                )
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: onClose) {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .navigationDestination(for: AuthRoute.self) { route in
                    coordinator.build(route: route)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: onClose) {
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                }
        }
    }
}
