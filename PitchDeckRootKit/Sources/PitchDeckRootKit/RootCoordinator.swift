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
import PitchDeckCoreKit

@MainActor
public final class RootCoordinator: ObservableObject {

    @Published public var selectedTab: Tab = .main

    public enum Tab {
        case main
        case cabinet
    }
    
    public init() { }

    public let main = MainCoordinator(service: StartupServiceImpl())
    public lazy var cabinet = CabinetCoordinator(
        cabinetService: CabinetServiceImpl(),
        startupService: StartupServiceImpl()
    )
    public let auth = AuthCoordinator(authService: AuthServiceImpl())
}
