//
//  StartupDetailViewSnapshotTests.swift
//  PitchDeckMainKitTests
//
//  Created by Anton Redkozubov on 20.01.2026.
//


import XCTest
import SwiftUI
import SnapshotTesting
import PitchDeckUIKit
import PitchDeckMainApiKit
@testable import PitchDeckMainKit

@MainActor
final class StartupDetailViewSnapshotTests: XCTestCase {
    
    func testStartupDetailView_empty_snapshot() {
        let viewModel = StartupDetailViewModel(
            documentId: "test-doc-1",
            service: MockStartupService()
        )
        let view = StartupDetailView(viewModel: viewModel)
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "StartupDetailView_empty"
        )
    }
    
    func testStartupDetailView_withData_snapshot() {
        let mockStartup = StartupItem(
            id: 1,
            documentId: "test-doc-1",
            title: "Test Startup",
            description: "Test Description",
            image: "test.jpg",
            category: "Tech",
            location: "San Francisco"
        )
        
        let viewModel = StartupDetailViewModel(
            documentId: "test-doc-1",
            service: MockStartupService()
        )
        viewModel.startupItem = mockStartup
        
        let view = StartupDetailView(
            viewModel: viewModel
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "StartupDetailView_with_data"
        )
    }
    
    func testStartupDetailView_loading_snapshot() {
        let viewModel = StartupDetailViewModel(
            documentId: "test-doc-1",
            service: MockStartupService()
        )
        viewModel.isLoading = true
        
        let view = StartupDetailView(
            viewModel: viewModel
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "StartupDetailView_loading"
        )
    }
    
    func testStartupDetailView_error_snapshot() {
        let viewModel = StartupDetailViewModel(
            documentId: "test-doc-1",
            service: MockStartupService()
        )
        viewModel.errorMessage = "Network error"
        
        let view = StartupDetailView(
            viewModel: viewModel
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "StartupDetailView_error"
        )
    }
}
