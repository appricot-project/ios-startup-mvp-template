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

public enum CabinetRoute: Hashable {
    case cabinet
    case createStartup
}

@MainActor
public final class CabinetCoordinator: BaseCoordinator<CabinetRoute> {
    
    public let cabinetService: CabinetService
    public let startupService: StartupService
    public let authService: AuthService
    public var onStartupCreated: (() -> Void)?
    public var onLogout: (() -> Void)?
    public weak var rootCoordinator: (any ObservableObject)?
    
    public private(set) lazy var cabinetViewModel: CabinetViewModel = {
        CabinetViewModel(cabinetService: cabinetService, startupService: startupService, authService: authService)
    }()
    
    public init(
        cabinetService: CabinetService,
        startupService: StartupService,
        authService: AuthService
    ) {
        self.cabinetService = cabinetService
        self.startupService = startupService
        self.authService = authService
        super.init()
    }
    
    @ViewBuilder
    public func build(route: CabinetRoute) -> some View {
        switch route {
        case .cabinet:
            buildCabinetView()
        case .createStartup:
            buildCreateStartupView()
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
}
