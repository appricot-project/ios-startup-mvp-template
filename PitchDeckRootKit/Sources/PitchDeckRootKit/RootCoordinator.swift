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

public final class RootCoordinator: ObservableObject {

    @Published public var selectedTab: Tab = .main

    public enum Tab {
        case main
        case cabinet
        case auth
    }
    
    public init() { }

    public let main = MainCoordinator()
    public let cabinet = CabinetCoordinator()
    public let auth = AuthCoordinator()
}
