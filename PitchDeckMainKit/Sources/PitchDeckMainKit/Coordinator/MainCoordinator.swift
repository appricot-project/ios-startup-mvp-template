//
//  MainCoordinator.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import Foundation
import SwiftUI
import PitchDeckMainApiKit
import PitchDeckNavigationApiKit

public enum MainRoute: Hashable {
    case details(documentId: String)
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .details(let documentId):
            hasher.combine("details")
            hasher.combine(documentId)
        }
    }
}

@MainActor
public final class MainCoordinator: BaseCoordinator<MainRoute> {
    
    public let service: StartupService
    
    public init(service: StartupService) {
        self.service = service
        super.init()
    }
    
    @ViewBuilder
    public func build(route: MainRoute) -> some View {
        switch route {
        case .details(let documentId):
            StartupDetailView(viewModel: StartupDetailViewModel(documentId: documentId, service: service))
        }
    }
}
