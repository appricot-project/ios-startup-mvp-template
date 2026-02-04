//
//  CreateStartupServiceImpl.swift
//  PitchDeckCabinetKit
//
//  Created by Anton Redkozubov on 03.02.2026.
//

import Foundation
import PitchDeckCabinetApiKit
import PitchDeckMainApiKit

public final class CreateStartupServiceImpl: CreateStartupService, @unchecked Sendable {
    
    private let startupService: StartupService
    
    public init(startupService: StartupService) {
        self.startupService = startupService
    }
    
    public func getStartupsCategories() async throws -> [CategoryItem] {
        return try await startupService.getStartupsCategories()
    }
    
    public func createStartup(request: CreateStartupRequest) async throws -> StartupItem {
        // TODO: Implement actual creation when API is ready
        throw CreateStartupError.notImplemented
    }
}

public enum CreateStartupError: LocalizedError {
    case notImplemented
    
    public var errorDescription: String? {
        switch self {
        case .notImplemented:
            return "Create startup functionality is not implemented yet"
        }
    }
}
