//
//  RootCoordinator.swift
//  PitchDeckRootKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import Foundation
import SwiftUI
import PitchDeckMainKit
import PitchDeckCabinetKit

@MainActor
public final class RootCoordinator: ObservableObject {

    @Published public var selectedTab: Tab = .main

    public enum Tab {
        case main
        case cabinet
    }
    
    public init() { }

    public let main = MainCoordinator(service: StartupServiceImpl())
    public let cabinet = CabinetCoordinator()
}
