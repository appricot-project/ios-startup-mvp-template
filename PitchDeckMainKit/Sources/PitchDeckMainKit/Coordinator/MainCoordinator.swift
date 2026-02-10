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
    case edit(documentId: String)
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .details(let documentId):
            hasher.combine("details")
            hasher.combine(documentId)
        case .edit(let documentId):
            hasher.combine("edit")
            hasher.combine(documentId)
        }
    }
}

@MainActor
public final class MainCoordinator: BaseCoordinator<MainRoute> {
    
    public let service: StartupService
    @Published public var currentUserEmail: String = ""
    private let startupEditNavigationService: StartupEditNavigationService = StartupEditNavigationServiceImpl(startupService: StartupServiceImpl())
    
    public lazy var viewModel: StartupListViewModel = {
        StartupListViewModel(service: service)
    }()
    
    public init(service: StartupService, currentUserEmail: String = "") {
        self.service = service
        self.currentUserEmail = currentUserEmail
        super.init()
    }
    
    @ViewBuilder
    public func build(route: MainRoute) -> some View {
        switch route {
        case .details(let documentId):
            StartupDetailView(
                viewModel: StartupDetailViewModel(documentId: documentId, service: service, currentUserEmail: currentUserEmail),
                onEditTapped: { [weak self] documentId in
                    self?.showEditScreen(documentId: documentId)
                },
                onDeleteSuccess: { [weak self] in
                    self?.viewModel.send(event: .onRefresh)
                    self?.pop()
                }
            )
        case .edit(let documentId):
            startupEditNavigationService.buildStartupEditView(
                documentId: documentId,
                onStartupUpdated: { [weak self] in
                    self?.viewModel.send(event: .onRefresh)
                    self?.pop()
                }
            )
        }
    }
    
    private func showEditScreen(documentId: String) {
        self.push(.edit(documentId: documentId))
    }
}
