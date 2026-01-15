//
//  AuthCoordinator.swift
//  PitchDeckAuthKit
//
//  Created by Anatoly Nevmerzhitsky on 10.12.2025.
//

import SwiftUI
import PitchDeckNavigationApiKit
import PitchDeckAuthApiKit

public enum AuthRoute: Hashable {
    case confirmation(String)
}

@MainActor
public final class AuthCoordinator: BaseCoordinator<AuthRoute> {

    public let authService: AuthService

    public init(authService: AuthService = AuthServiceImpl()) {
        self.authService = authService
        super.init()
    }

    @ViewBuilder
    public func build(route: AuthRoute) -> some View {
        switch route {
        case .confirmation(let email):
            AuthConfirmationScreen(email: email)
        }
    }
}
