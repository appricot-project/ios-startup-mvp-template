//
//  File.swift
//  PitchDeckAuthKit
//
//  Created by Anatoly Nevmerzhitsky on 10.12.2025.
//

import Foundation
import SwiftUI
import PitchDeckNavigationApiKit

public enum AuthRoute: Hashable {
    case details(id: Int)
}

public final class AuthCoordinator: BaseCoordinator<AuthRoute> {

    @ViewBuilder
    public func build(route: AuthRoute) -> some View {
        switch route {
        case .details(let id):
            AuthMainScreenScreen()
        }
    }
}
