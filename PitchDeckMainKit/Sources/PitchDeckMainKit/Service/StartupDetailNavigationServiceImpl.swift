//
//  StartupDetailNavigationServiceImpl.swift
//  PitchDeckMainKit
//
//  Created by Cascade on 10.02.2026.
//

import Foundation
import SwiftUI
import PitchDeckMainApiKit

public final class StartupDetailNavigationServiceImpl: @MainActor StartupDetailNavigationService {
    
    private let startupService: StartupService
    
    public init(startupService: StartupService) {
        self.startupService = startupService
    }
    
    @MainActor
    public func buildStartupDetailView(documentId: String, currentUserEmail: String, onEditTapped: ((String) -> Void)? = nil) -> AnyView {
        let viewModel = StartupDetailViewModel(documentId: documentId, service: startupService, currentUserEmail: currentUserEmail)
        return AnyView(StartupDetailView(viewModel: viewModel, onEditTapped: onEditTapped))
    }
}
