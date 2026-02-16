//
//  CabinetScreenSnapshotTests.swift
//  PitchDeckCabinetKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import XCTest
import SwiftUI
import SnapshotTesting
import PitchDeckUIKit
import PitchDeckCabinetApiKit
@testable import PitchDeckMainApiKit
@testable import PitchDeckAuthApiKit
@testable import PitchDeckCabinetKit

@MainActor
final class CabinetScreenSnapshotTests: XCTestCase {
    
    func testCabinetScreen_empty_snapshot() {
        let coordinator = CabinetCoordinator(
            cabinetService: MockCabinetService(),
            startupService: MockStartupService(),
            authService: MockAuthService(),
            startupDetailNavigationService: MockStartupDetailNavigationService(),
            startupEditNavigationService: MockStartupEditNavigationService()
        )
        let view = CabinetScreen(
            viewModel: coordinator.cabinetViewModel,
            coordinator: coordinator
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "CabinetScreen_empty"
        )
    }
    
    func testCabinetScreen_withData_snapshot() {
        let mockStartups = MockStartupService.createMockStartupItems(count: 3)
        let mockProfile = UserProfileData(
            firstName: "Test",
            lastName: "User",
            email: "test@example.com"
        )
        
        let coordinator = CabinetCoordinator(
            cabinetService: MockCabinetService(),
            startupService: MockStartupService(),
            authService: MockAuthService(),
            startupDetailNavigationService: MockStartupDetailNavigationService(),
            startupEditNavigationService: MockStartupEditNavigationService()
        )
        coordinator.cabinetViewModel.userStartups = mockStartups
        coordinator.cabinetViewModel.userProfile = mockProfile
        
        let view = CabinetScreen(
            viewModel: coordinator.cabinetViewModel,
            coordinator: coordinator
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "CabinetScreen_with_data"
        )
    }
    
    func testCabinetScreen_loading_snapshot() {
        let coordinator = CabinetCoordinator(
            cabinetService: MockCabinetService(),
            startupService: MockStartupService(),
            authService: MockAuthService(),
            startupDetailNavigationService: MockStartupDetailNavigationService(),
            startupEditNavigationService: MockStartupEditNavigationService()
        )
        coordinator.cabinetViewModel.isLoading = true
        
        let view = CabinetScreen(
            viewModel: coordinator.cabinetViewModel,
            coordinator: coordinator
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "CabinetScreen_loading"
        )
    }
    
    func testCabinetScreen_error_snapshot() {
        let coordinator = CabinetCoordinator(
            cabinetService: MockCabinetService(),
            startupService: MockStartupService(),
            authService: MockAuthService(),
            startupDetailNavigationService: MockStartupDetailNavigationService(),
            startupEditNavigationService: MockStartupEditNavigationService()
        )
        coordinator.cabinetViewModel.errorMessage = "Network error"
        
        let view = CabinetScreen(
            viewModel: coordinator.cabinetViewModel,
            coordinator: coordinator
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "CabinetScreen_error"
        )
    }
    
    func testCabinetScreen_withProfile_snapshot() {
        let mockProfile = UserProfileData(
            firstName: "Test",
            lastName: "User",
            email: "test@example.com"
        )
        
        let coordinator = CabinetCoordinator(
            cabinetService: MockCabinetService(),
            startupService: MockStartupService(),
            authService: MockAuthService(),
            startupDetailNavigationService: MockStartupDetailNavigationService(),
            startupEditNavigationService: MockStartupEditNavigationService()
        )
        coordinator.cabinetViewModel.userProfile = mockProfile
        
        let view = CabinetScreen(
            viewModel: coordinator.cabinetViewModel,
            coordinator: coordinator
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "CabinetScreen_with_profile"
        )
    }
    
    func testCabinetScreen_withCategories_snapshot() {        
        let coordinator = CabinetCoordinator(
            cabinetService: MockCabinetService(),
            startupService: MockStartupService(),
            authService: MockAuthService(),
            startupDetailNavigationService: MockStartupDetailNavigationService(),
            startupEditNavigationService: MockStartupEditNavigationService()
        )
        
        let view = CabinetScreen(
            viewModel: coordinator.cabinetViewModel,
            coordinator: coordinator
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "CabinetScreen_with_categories"
        )
    }
    
    func testCabinetScreen_profileError_snapshot() {
        let coordinator = CabinetCoordinator(
            cabinetService: MockCabinetService(),
            startupService: MockStartupService(),
            authService: MockAuthService(),
            startupDetailNavigationService: MockStartupDetailNavigationService(),
            startupEditNavigationService: MockStartupEditNavigationService()
        )
        coordinator.cabinetViewModel.errorMessage = "Profile loading failed"
        
        let view = CabinetScreen(
            viewModel: coordinator.cabinetViewModel,
            coordinator: coordinator
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "CabinetScreen_profile_error"
        )
    }
}
