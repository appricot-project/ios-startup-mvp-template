//
//  StartupListViewSnapshotTests.swift
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
final class StartupListViewSnapshotTests: XCTestCase {
    
    func testStartupListView_empty_snapshot() {
        let viewModel = StartupListViewModel(service: MockStartupService())
        let view = StartupsView(
            viewModel: viewModel,
            onStartupSelected: { _ in }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "StartupListView_empty"
        )
    }
    
    func testStartupListView_withData_snapshot() {
        let mockStartups = MockStartupService.createMockStartupItems(count: 3)
        let mockCategories = MockStartupService.createMockCategoryItems(count: 2)
        let viewModel = StartupListViewModel(service: MockStartupService())
        viewModel.startups = mockStartups
        viewModel.categories = mockCategories
        let view = StartupsView(
            viewModel: viewModel,
            onStartupSelected: { _ in }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "StartupListView_with_data"
        )
    }
    
    func testStartupListView_loading_snapshot() {
        let viewModel = StartupListViewModel(service: MockStartupService())
        viewModel.isLoading = true
        
        let view = StartupsView(
            viewModel: viewModel,
            onStartupSelected: { _ in }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "StartupListView_loading"
        )
    }
    
    func testStartupListView_error_snapshot() {
        let viewModel = StartupListViewModel(service: MockStartupService())
        viewModel.errorMessage = "Network error"
        
        let view = StartupsView(
            viewModel: viewModel,
            onStartupSelected: { _ in }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "StartupListView_error"
        )
    }
    
    func testStartupListView_withSearch_snapshot() {
        let viewModel = StartupListViewModel(service: MockStartupService())
        viewModel.searchText = "Test search"
        
        let view = StartupsView(
            viewModel: viewModel,
            onStartupSelected: { _ in }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "StartupListView_with_search"
        )
    }
    
    func testStartupListView_withCategories_snapshot() {
        let mockCategories = MockStartupService.createMockCategoryItems(count: 3)
        
        let viewModel = StartupListViewModel(service: MockStartupService())
        viewModel.categories = mockCategories
        viewModel.selectedCategoryId = 2
        
        let view = StartupsView(
            viewModel: viewModel,
            onStartupSelected: { _ in }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "StartupListView_with_categories"
        )
    }
}
