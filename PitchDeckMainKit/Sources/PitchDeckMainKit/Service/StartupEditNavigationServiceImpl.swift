//
//  StartupEditNavigationServiceImpl.swift
//  PitchDeckMainKit
//
//  Created by Cascade on 10.02.2026.
//

import Foundation
import SwiftUI
import PitchDeckMainApiKit

public final class StartupEditNavigationServiceImpl: @MainActor StartupEditNavigationService {
    
    private let startupService: StartupService
    
    public init(startupService: StartupService) {
        self.startupService = startupService
    }
    
    @MainActor public func buildStartupEditView(documentId: String, onStartupUpdated: @escaping () -> Void) -> AnyView {
        let viewModel = EditStartupViewModel(startupService: startupService, documentId: documentId)
        return AnyView(EditStartupScreen(viewModel: viewModel, onStartupUpdated: onStartupUpdated))
    }
}
