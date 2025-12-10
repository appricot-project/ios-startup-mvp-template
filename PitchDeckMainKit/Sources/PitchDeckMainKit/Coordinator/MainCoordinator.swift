//
//  MainCoordinator.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import Foundation
import SwiftUI
import PitchDeckNavigationApiKit

public enum MainRoute: Hashable {
    case details(id: Int)
}

public final class MainCoordinator: BaseCoordinator<MainRoute> {
    
    @ViewBuilder
    public func build(route: MainRoute) -> some View {
        switch route {
        case .details(let id):
            MainDetailsScreen(id: id)
        }
    }
}
