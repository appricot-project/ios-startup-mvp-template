//
//  CreateStartupScreenSnapshotTests.swift
//  PitchDeckCabinetKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import XCTest
import SwiftUI
import SnapshotTesting
import PitchDeckUIKit
@testable import PitchDeckMainApiKit
@testable import PitchDeckCabinetKit

@MainActor
final class CreateStartupScreenSnapshotTests: XCTestCase {
    
    func testCreateStartupScreen_empty_snapshot() {
        let viewModel = CreateStartupViewModel(
            startupService: MockStartupService(),
            cabinetService: MockCabinetService()
        )
        let view = CreateStartupScreen(
            viewModel: viewModel,
            onStartupCreated: { }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "CreateStartupScreen_empty"
        )
    }
    
    func testCreateStartupScreen_withData_snapshot() {
        let viewModel = CreateStartupViewModel(
            startupService: MockStartupService(),
            cabinetService: MockCabinetService()
        )
        viewModel.ownerEmail = "test@example.com"
        viewModel.title = "Test Startup"
        viewModel.description = "Test Description"
        viewModel.selectedCategoryId = "1"
        viewModel.location = "San Francisco"
        viewModel.selectedImageData = Data([0x01, 0x02, 0x03])
        
        let view = CreateStartupScreen(
            viewModel: viewModel,
            onStartupCreated: { }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "CreateStartupScreen_with_data"
        )
    }
    
    func testCreateStartupScreen_creating_snapshot() {
        let viewModel = CreateStartupViewModel(
            startupService: MockStartupService(),
            cabinetService: MockCabinetService()
        )
        viewModel.ownerEmail = "test@example.com"
        viewModel.title = "Test Startup"
        viewModel.description = "Test Description"
        viewModel.selectedCategoryId = "1"
        viewModel.location = "San Francisco"
        viewModel.isCreating = true
        
        let view = CreateStartupScreen(
            viewModel: viewModel,
            onStartupCreated: { }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "CreateStartupScreen_creating"
        )
    }
    
    func testCreateStartupScreen_error_snapshot() {
        let viewModel = CreateStartupViewModel(
            startupService: MockStartupService(),
            cabinetService: MockCabinetService()
        )
        viewModel.errorMessage = "Creation failed"
        
        let view = CreateStartupScreen(
            viewModel: viewModel,
            onStartupCreated: { }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "CreateStartupScreen_error"
        )
    }
    
    func testCreateStartupScreen_withImage_snapshot() {
        let viewModel = CreateStartupViewModel(
            startupService: MockStartupService(),
            cabinetService: MockCabinetService()
        )
        viewModel.ownerEmail = "test@example.com"
        viewModel.title = "Test Startup"
        viewModel.description = "Test Description"
        viewModel.selectedCategoryId = "1"
        viewModel.location = "San Francisco"
        viewModel.selectedImageData = Data([0x01, 0x02, 0x03, 0x04, 0x05])
        
        let view = CreateStartupScreen(
            viewModel: viewModel,
            onStartupCreated: { }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "CreateStartupScreen_with_image"
        )
    }
    
    func testCreateStartupScreen_invalidForm_snapshot() {
        let viewModel = CreateStartupViewModel(
            startupService: MockStartupService(),
            cabinetService: MockCabinetService()
        )
        viewModel.ownerEmail = "test@example.com"
        viewModel.title = ""
        viewModel.description = "Test Description"
        viewModel.selectedCategoryId = "1"
        viewModel.location = "San Francisco"
        
        let view = CreateStartupScreen(
            viewModel: viewModel,
            onStartupCreated: { }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "CreateStartupScreen_invalid_form"
        )
    }
}
