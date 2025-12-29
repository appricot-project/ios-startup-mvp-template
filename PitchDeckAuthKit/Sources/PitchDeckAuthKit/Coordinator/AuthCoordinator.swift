//
//  File.swift
//  PitchDeckAuthKit
//
//  Created by Anatoly Nevmerzhitsky on 10.12.2025.
//

import SwiftUI
import PitchDeckNavigationApiKit

public enum AuthRoute: Hashable {
    case confirmation(String)
}

public final class AuthCoordinator: BaseCoordinator<AuthRoute> {

    @ViewBuilder
    public func build(route: AuthRoute) -> some View {
        switch route {
        case .confirmation(let email):
            AuthConfirmationScreen(email: email)
        }
    }
}
