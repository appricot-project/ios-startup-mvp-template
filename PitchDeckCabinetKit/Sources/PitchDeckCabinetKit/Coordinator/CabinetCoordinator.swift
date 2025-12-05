//
//  CabinetCoordinator.swift
//  PitchDeckCabinetKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import Foundation
import SwiftUI
import PitchDeckNavigationApiKit

public enum CabinetRoute: Hashable {
    case accountSettings
}

public final class CabinetCoordinator: BaseCoordinator<CabinetRoute> {

    @ViewBuilder
    public func build(route: CabinetRoute) -> some View {
        switch route {
        case .accountSettings:
            AccountSettingsScreen()
        }
    }
}
