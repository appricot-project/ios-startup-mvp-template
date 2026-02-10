//
//  CabinetCoordinator.swift
//  PitchDeckCabinetKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import Foundation
import SwiftUI
import PitchDeckNavigationApiKit
import PitchDeckCabinetApiKit
import PitchDeckMainApiKit
import PitchDeckAuthApiKit
import PitchDeckCoreKit

public enum CabinetRoute: Hashable {
    case cabinet
    case createStartup
    case details(documentId: String)
    case edit(documentId: String)
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .cabinet:
            hasher.combine("cabinet")
        case .createStartup:
            hasher.combine("createStartup")
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
public final class CabinetCoordinator: BaseCoordinator<CabinetRoute> {
    
    public let cabinetService: CabinetService
    public let startupService: StartupService
    public let authService: AuthService
    public let startupDetailNavigationService: StartupDetailNavigationService
    public let startupEditNavigationService: StartupEditNavigationService
    public var onStartupCreated: (() -> Void)?
    public var onLogout: (() -> Void)?
    public weak var rootCoordinator: (any ObservableObject)?
    
    public private(set) lazy var cabinetViewModel: CabinetViewModel = {
        CabinetViewModel(cabinetService: cabinetService, startupService: startupService, authService: authService)
    }()
    
    public init(
        cabinetService: CabinetService,
        startupService: StartupService,
        authService: AuthService,
        startupDetailNavigationService: StartupDetailNavigationService,
        startupEditNavigationService: StartupEditNavigationService
    ) {
        self.cabinetService = cabinetService
        self.startupService = startupService
        self.authService = authService
        self.startupDetailNavigationService = startupDetailNavigationService
        self.startupEditNavigationService = startupEditNavigationService
        super.init()
    }
    
    @ViewBuilder
    public func build(route: CabinetRoute) -> some View {
        switch route {
        case .cabinet:
            buildCabinetView()
        case .createStartup:
            buildCreateStartupView()
        case .details(let documentId):
            buildDetailsView(documentId: documentId)
        case .edit(let documentId):
            buildEditView(documentId: documentId)
        }
    }
}

// MARK: - Private builders

private extension CabinetCoordinator {
    func buildCabinetView() -> some View {
        return CabinetScreen(
            viewModel: cabinetViewModel,
            coordinator: self
        )
    }
    
    func buildCreateStartupView() -> some View {
        let viewModel = CreateStartupViewModel(startupService: startupService, cabinetService: cabinetService)
        return CreateStartupScreen(
            viewModel: viewModel,
            onStartupCreated: { [weak self] in
                self?.onStartupCreated?()
                self?.cabinetViewModel.send(event: .refreshAll)
                self?.pop()
            }
        )
    }
    
    func buildEditView(documentId: String) -> some View {
        return startupEditNavigationService.buildStartupEditView(
            documentId: documentId,
            onStartupUpdated: { [weak self] in
                self?.cabinetViewModel.send(event: .refreshAll)
                self?.pop()
            }
        )
    }
    
    func buildDetailsView(documentId: String) -> some View {
        let currentUserEmail = cabinetViewModel.userProfile?.email ?? ""
        return startupDetailNavigationService.buildStartupDetailView(
            documentId: documentId, 
            currentUserEmail: currentUserEmail,
            onEditTapped: { [weak self] documentId in
                self?.push(.edit(documentId: documentId))
            },
            onDeleteSuccess: { [weak self] in
                Task { @MainActor in
                    do {
                        try await ApolloWebClient.shared.apollo.clearCache()
                    } catch {
                        print("Failed to clear Apollo cache: \(error)")
                    }
                    self?.cabinetViewModel.send(event: .refreshAll)
                    self?.popToRoot()
                }
            }
        )
    }
}
