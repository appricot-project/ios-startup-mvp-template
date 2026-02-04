//
//  RootCoordinator.swift
//  PitchDeckRootKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import SwiftUI
import PitchDeckMainKit
import PitchDeckCabinetKit
import PitchDeckAuthKit

@MainActor
public final class RootCoordinator: ObservableObject {

    @Published public var selectedTab: Tab = .main

    public enum Tab {
        case main
        case cabinet
    }
    
    public init() { }

    public let main = MainCoordinator(service: StartupServiceImpl())
    public let cabinet = CabinetCoordinator(cabinetService: CabinetServiceImpl(localStorage: <#T##any LocalStorage#>, startupService: <#T##any StartupService#>), createStartupService: <#any CreateStartupService#>)
    public let auth = AuthCoordinator(authService: AuthServiceImpl())
}
