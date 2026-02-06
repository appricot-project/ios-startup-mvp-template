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

public enum CabinetRoute: Hashable {
    case cabinet
    case createStartup
}

@MainActor
public final class CabinetCoordinator: BaseCoordinator<CabinetRoute> {
    
    public let cabinetService: CabinetService
    public let startupService: StartupService
    public var onStartupCreated: (() -> Void)?
    public private(set) var cabinetViewModel: CabinetViewModel?
    
    public init(
        cabinetService: CabinetService,
        startupService: StartupService
    ) {
        self.cabinetService = cabinetService
        self.startupService = startupService
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
        let viewModel = CabinetViewModel(cabinetService: cabinetService, startupService: startupService)
        self.cabinetViewModel = viewModel
        return CabinetScreen(
            viewModel: viewModel,
            coordinator: self
        )
    }
    
    func buildCreateStartupView() -> some View {
        let viewModel = CreateStartupViewModel(startupService: startupService)
        return CreateStartupScreen(
            viewModel: viewModel,
            onStartupCreated: { [weak self] in
                self?.onStartupCreated?()
                self?.cabinetViewModel?.send(event: .refreshStartups)
                self?.pop()
            }
        )
    }
}
