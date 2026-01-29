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
    case login(prefillEmail: String?)
    case registration
    case confirmation(String)
}

@MainActor
public final class AuthCoordinator: BaseCoordinator<AuthRoute> {

    public let authService: AuthService
    public var onAuthorizationCompleted: (() -> Void)?

    public init(authService: AuthService = AuthServiceImpl()) {
        self.authService = authService
        super.init()
    }

    @ViewBuilder
    public func build(route: AuthRoute) -> some View {
        switch route {
        case .login(let prefillEmail):
            buildLoginView(prefillEmail: prefillEmail)
        case .registration:
            buildRegistrationView()
        case .confirmation(let email):
            AuthConfirmationScreen(
                email: email,
                onConfirmationSuccess: { [weak self] in
                    guard let self else { return }
                    onAuthorizationCompleted?()
                }
            )
        }
    }
}

// MARK: - Private builders

private extension AuthCoordinator {
    func buildLoginView(prefillEmail: String?) -> some View {
        let viewModel = AuthMainViewModel(authService: authService)
        viewModel.email = prefillEmail ?? ""
        return AuthMainScreen(viewModel: viewModel, onSelectConfirmation: { email in
            self.push(.confirmation(email))
        })
    }

    func buildRegistrationView() -> some View {
        let viewModel = AuthRegistrationViewModel()
        return AuthRegistrationScreen(viewModel: viewModel, onRegistered: { email in
            self.push(.login(prefillEmail: email))
        })
    }
}
