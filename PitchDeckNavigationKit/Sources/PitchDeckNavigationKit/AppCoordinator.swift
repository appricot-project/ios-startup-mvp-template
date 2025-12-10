//
//  AppCoordinator.swift
//  PitchDeckNavigationKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import Foundation
import SwiftUI
import PitchDeckRootKit

public final class AppCoordinator: ObservableObject {

    public let rootCoordinator: RootCoordinator

    public init() {
        self.rootCoordinator = RootCoordinator()
    }
}
