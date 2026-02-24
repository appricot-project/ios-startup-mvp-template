//
//  AppRootView.swift
//  PitchDeckNavigationKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import Foundation
import SwiftUI
import PitchDeckRootKit

public struct AppRootView: View {

    @StateObject var coordinator: AppCoordinator

    public init(coordinator: AppCoordinator) {
        self._coordinator = StateObject(wrappedValue: coordinator)
    }

    public var body: some View {
        RootFlowView(coordinator: coordinator.rootCoordinator)
    }
}
