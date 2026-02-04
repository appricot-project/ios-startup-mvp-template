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
    public let createStartupService: CreateStartupService
    public var onStartupCreated: (() -> Void)?
    
    public init(
        cabinetService: CabinetService,
        createStartupService: CreateStartupService
    ) {
        self.cabinetService = cabinetService
        self.createStartupService = createStartupService
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
        let viewModel = CabinetViewModel(cabinetService: cabinetService)
        return CabinetScreen(
            viewModel: viewModel,
            coordinator: self
        )
    }
    
    func buildCreateStartupView() -> some View {
        let viewModel = CreateStartupViewModel(createStartupService: createStartupService)
        return CreateStartupScreen(
            viewModel: viewModel,
            onStartupCreated: { [weak self] in
                self?.onStartupCreated?()
                self?.pop()
            }
        )
    }
}
