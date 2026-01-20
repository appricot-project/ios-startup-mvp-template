//
//  StartupListViewModelTests.swift
//  PitchDeckMainKitTests
//
//  Created by Anton Redkozubov on 20.01.2026.
//

import XCTest
@testable import PitchDeckMainKit
@testable import PitchDeckMainApiKit

@MainActor
final class StartupListViewModelTests: XCTestCase {
    
    var sut: StartupListViewModel!
    var mockService: MockStartupService!
    
    override func setUp() async throws {
        mockService = MockStartupService()
        sut = StartupListViewModel(service: mockService)
    }
    
    override func tearDown() async throws {
        mockService.reset()
        sut = nil
        mockService = nil
    }
    
    // MARK: - Methods Tests
    
    func testOnAppear_loadsDataSuccessfully() async throws {
        let mockStartups = MockStartupService.createMockStartupItems(count: 3)
        let mockCategories = MockStartupService.createMockCategoryItems(count: 2)
        let mockPageInfo = MockStartupService.createMockPageInfo(page: 1, pageSize: 10, total: 3)
        
        mockService.mockStartups = mockStartups
        mockService.mockCategories = mockCategories
        mockService.mockPageInfo = mockPageInfo
        
        sut.send(event: .onAppear)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(sut.startups.count, 3)
        XCTAssertEqual(sut.categories.count, 2)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.isInitialLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(mockService.getStartupsCallCount, 1)
        XCTAssertEqual(mockService.getStartupsCategoriesCallCount, 1)
    }
    
    func testOnAppear_handlesError() async throws {
        mockService.shouldFailGetStartups = true
        mockService.errorToThrow = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        
        sut.send(event: .onAppear)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertTrue(sut.startups.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.isInitialLoading)
        XCTAssertEqual(sut.errorMessage, "Network error")
        XCTAssertEqual(mockService.getStartupsCallCount, 1)
    }
    
    func testOnAppears_setsLoadingStateCorrectly() async throws {
        let mockStartups = MockStartupService.createMockStartupItems(count: 1)
        let mockPageInfo = MockStartupService.createMockPageInfo(page: 1, pageSize: 10, total: 1)
        
        mockService.mockStartups = mockStartups
        mockService.mockPageInfo = mockPageInfo
        
        sut.send(event: .onAppear)
        
        XCTAssertTrue(sut.isInitialLoading)
        XCTAssertNil(sut.errorMessage)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.isInitialLoading)
    }
    
    func testOnAppear_cancelsPreviousTask() async throws {
        let mockStartups = MockStartupService.createMockStartupItems(count: 1)
        let mockPageInfo = MockStartupService.createMockPageInfo(page: 1, pageSize: 10, total: 1)
        
        mockService.mockStartups = mockStartups
        mockService.mockPageInfo = mockPageInfo
        
        sut.send(event: .onAppear)
        try await Task.sleep(nanoseconds: 50_000_000)
        
        sut.send(event: .onAppear)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(mockService.getStartupsCallCount, 2)
        XCTAssertEqual(mockService.getStartupsCategoriesCallCount, 2)
    }
    
    // MARK: - Search Tests
    
    func testOnSearch_filtersData() async throws {
        let mockStartups = MockStartupService.createMockStartupItems(count: 5)
        let mockPageInfo = MockStartupService.createMockPageInfo(page: 1, pageSize: 10, total: 5)
        
        mockService.mockStartups = mockStartups
        mockService.mockPageInfo = mockPageInfo
        
        sut.send(event: .onSearch("Test"))
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(mockService.getStartupsCallCount, 1)
        XCTAssertEqual(mockService.lastGetStartupsTitle, "Test")
        XCTAssertFalse(sut.isLoading)
    }
    
    func testOnSearch_emptyText_loadsAllData() async throws {
        let mockStartups = MockStartupService.createMockStartupItems(count: 3)
        let mockPageInfo = MockStartupService.createMockPageInfo(page: 1, pageSize: 10, total: 3)
        
        mockService.mockStartups = mockStartups
        mockService.mockPageInfo = mockPageInfo
        
        sut.send(event: .onSearch(""))
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(mockService.getStartupsCallCount, 0)
        XCTAssertEqual(mockService.lastGetStartupsTitle, nil)
        XCTAssertFalse(sut.isLoading)
    }
    
    // MARK: - Category Selection Tests
    
    func testOnSelectedCategory_filtersData() async throws {
        let mockStartups = MockStartupService.createMockStartupItems(count: 3)
        let mockPageInfo = MockStartupService.createMockPageInfo(page: 1, pageSize: 10, total: 3)
        
        mockService.mockStartups = mockStartups
        mockService.mockPageInfo = mockPageInfo
        
        sut.send(event: .onSelectedCategory(2))
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(mockService.getStartupsCallCount, 1)
        XCTAssertEqual(mockService.lastGetStartupsCategoryId, 2)
        XCTAssertEqual(sut.selectedCategoryId, 2)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testOnSelectedCategory_sameCategory_doesNotReload() async throws {
        sut.selectedCategoryId = 2
        
        sut.send(event: .onSelectedCategory(2))
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(mockService.getStartupsCallCount, 0)
        XCTAssertFalse(sut.isLoading)
    }
    
    // MARK: - Load More Data Tests
    
    func testOnLoadMore_loadsMoreData() async throws {
        let mockStartups = MockStartupService.createMockStartupItems(count: 15)
        let mockPageInfo = MockStartupService.createMockPageInfo(page: 1, pageSize: 10, total: 15)
        
        mockService.mockStartups = mockStartups
        mockService.mockPageInfo = mockPageInfo
        
        sut.send(event: .onAppear)
        try await Task.sleep(nanoseconds: 500_000_000)
        
        mockService.getStartupsCallCount = 0
        
        sut.send(event: .onLoadMore)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(mockService.getStartupsCallCount, 1)
        XCTAssertEqual(mockService.lastGetStartupsPage, 2)
        XCTAssertFalse(sut.isLoadingMore)
        XCTAssertEqual(sut.currentPage, 2)
    }
    
    func testOnLoadMore_whenNoMoreData_doesNotLoad() async throws {
        let mockStartups = MockStartupService.createMockStartupItems(count: 5)
        let mockPageInfo = MockStartupService.createMockPageInfo(page: 1, pageSize: 10, total: 5)
        
        mockService.mockStartups = mockStartups
        mockService.mockPageInfo = mockPageInfo
        
        sut.send(event: .onAppear)
        try await Task.sleep(nanoseconds: 500_000_000)
        
        mockService.getStartupsCallCount = 0
        
        sut.send(event: .onLoadMore)
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(mockService.getStartupsCallCount, 0)
        XCTAssertFalse(sut.isLoadingMore)
    }
    
    func testOnLoadMore_whenAlreadyLoading_doesNotLoad() async throws {
        sut.isLoadingMore = true
        
        sut.send(event: .onLoadMore)
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(mockService.getStartupsCallCount, 0)
        XCTAssertTrue(sut.isLoadingMore)
    }
    
    // MARK: - Task Cancellation Tests
    
    func testTaskCancellation_onNewEvent() async throws {
        let mockStartups = MockStartupService.createMockStartupItems(count: 3)
        let mockPageInfo = MockStartupService.createMockPageInfo(page: 1, pageSize: 10, total: 3)
        
        mockService.mockStartups = mockStartups
        mockService.mockPageInfo = mockPageInfo
        
        sut.send(event: .onAppear)
        try await Task.sleep(nanoseconds: 50_000_000)
        
        sut.send(event: .onSearch("New search"))
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(mockService.getStartupsCallCount, 2)
        XCTAssertEqual(mockService.lastGetStartupsTitle, "New search")
    }
}
