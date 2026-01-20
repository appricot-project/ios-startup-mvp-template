//
//  StartupDetailViewModelTests.swift
//  PitchDeckMainKitTests
//
//  Created by Anton Redkozubov on 20.01.2026.
//

import XCTest
@testable import PitchDeckMainKit
@testable import PitchDeckMainApiKit

@MainActor
final class StartupDetailViewModelTests: XCTestCase {
    
    var sut: StartupDetailViewModel!
    var mockService: MockStartupService!
    
    override func setUp() async throws {
        mockService = MockStartupService()
        sut = StartupDetailViewModel(documentId: "test-doc-1", service: mockService)
    }
    
    override func tearDown() async throws {
        mockService.reset()
        sut = nil
        mockService = nil
    }
    
    // MARK: - Methods Tests
    
    func testOnAppear_loadsStartupSuccessfully() async throws {
        let mockStartup = StartupItem(
            id: 1,
            documentId: "test-doc-1",
            title: "Test Startup",
            description: "Test Description",
            image: "test.jpg",
            category: "Tech",
            location: "San Francisco"
        )
        mockService.mockStartupDetail = mockStartup
        
        sut.send(event: .onAppear)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(sut.startupItem?.id, mockStartup.id)
        XCTAssertEqual(sut.startupItem?.title, mockStartup.title)
        XCTAssertEqual(sut.startupItem?.documentId, mockStartup.documentId)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(mockService.getStartupCallCount, 1)
        XCTAssertEqual(mockService.lastGetStartupDocumentId, "test-doc-1")
    }
    
    func testOnAppear_handlesError() async throws {
        mockService.shouldFailGetStartup = true
        mockService.errorToThrow = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Startup not found"])
        
        sut.send(event: .onAppear)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertNil(sut.startupItem)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.errorMessage, "Startup not found")
        XCTAssertEqual(mockService.getStartupCallCount, 1)
        XCTAssertEqual(mockService.lastGetStartupDocumentId, "test-doc-1")
    }
    
    func testOnAppears_setsLoadingStateCorrectly() async throws {

        let mockStartup = StartupItem(
            id: 1,
            documentId: "test-doc-1",
            title: "Test Startup",
            description: "Test Description",
            image: "test.jpg",
            category: "Tech",
            location: "San Francisco"
        )
        mockService.mockStartupDetail = mockStartup
        
        sut.send(event: .onAppear)
        
        XCTAssertNil(sut.errorMessage)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertFalse(sut.isLoading)
    }
    
    func testOnAppear_cancelsPreviousTask() async throws {
        let mockStartup = StartupItem(
            id: 1,
            documentId: "test-doc-1",
            title: "Test Startup",
            description: "Test Description",
            image: "test.jpg",
            category: "Tech",
            location: "San Francisco"
        )
        mockService.mockStartupDetail = mockStartup
        
        sut.send(event: .onAppear)
        try await Task.sleep(nanoseconds: 50_000_000)
        
        sut.send(event: .onAppear)
        
        try await Task.sleep(nanoseconds: 500_000_000)
    
        XCTAssertEqual(mockService.getStartupCallCount, 2)
        XCTAssertEqual(mockService.lastGetStartupDocumentId, "test-doc-1")
    }
    
   // MARK: - Share Tests
    
    func testOnShareTapped_setsShowShareSheet() async throws {
        XCTAssertFalse(sut.showShareSheet)
        sut.send(event: .onShareTapped)
        
        try await Task.sleep(until: .now + .nanoseconds(100_000_000), tolerance: .milliseconds(1))
        
        XCTAssertTrue(sut.showShareSheet)
    }
    
    func testShareStartup_returnsCorrectData() {
        let mockStartup = StartupItem(
            id: 1,
            documentId: "test-doc-1",
            title: "Test Startup",
            description: "Test Description",
            image: "test.jpg",
            category: "Tech",
            location: "San Francisco"
        )
        sut.startupItem = mockStartup
        
        let shareData = sut.shareStartup()
        
        XCTAssertEqual(shareData.count, 2)
        XCTAssertEqual(shareData[0] as? String, "Check out this startup: Test Startup")
        XCTAssertTrue(shareData[1] is URL)
        XCTAssertEqual((shareData[1] as? URL)?.absoluteString, "https://example.com/startup/1")
    }
    
    func testShareStartup_withNilStartup_returnsEmpty() {
        sut.startupItem = nil
        
        let shareData = sut.shareStartup()
    
        XCTAssertTrue(shareData.isEmpty)
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization_setsCorrectDocumentId() async throws {
        let documentId = "custom-doc-123"
        let viewModel = StartupDetailViewModel(documentId: documentId, service: mockService)
        
        viewModel.send(event: .onAppear)
        
        try await Task.sleep(until: .now + .nanoseconds(100_000_000), tolerance: .milliseconds(1))

        XCTAssertEqual(mockService.lastGetStartupDocumentId, documentId)
    }
    
    func testInitialization_withEmptyDocumentId_stillWorks() async throws {
        let documentId = ""
        let viewModel = StartupDetailViewModel(documentId: documentId, service: mockService)
        
        viewModel.send(event: .onAppear)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(mockService.lastGetStartupDocumentId, documentId)
    }
    
    // MARK: - Error Handling Tests
    
    func testOnAppear_withCancellationError_doesNotSetErrorMessage() async throws {
        mockService.shouldFailGetStartup = true
        mockService.errorToThrow = CancellationError()
        
        sut.send(event: .onAppear)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertNil(sut.startupItem)
        XCTAssertEqual(sut.isLoading, true)
    }
    
    func testOnAppear_withNetworkError_setsErrorMessage() async throws {
        mockService.shouldFailGetStartup = true
        mockService.errorToThrow = NSError(domain: "NetworkError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Network timeout"])

        sut.send(event: .onAppear)
        
        try await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertNil(sut.startupItem)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.errorMessage, "Network timeout")
    }
    
    // MARK: - Multiple Load Data Tests
    
    func testMultipleOnAppear_calls_loadsCorrectly() async throws {
        let mockStartup1 = StartupItem(
            id: 1,
            documentId: "test-doc-1",
            title: "Test Startup 1",
            description: "Test Description 1",
            image: "test1.jpg",
            category: "Tech",
            location: "San Francisco"
        )
        let mockStartup2 = StartupItem(
            id: 2,
            documentId: "test-doc-1",
            title: "Test Startup 2",
            description: "Test Description 2",
            image: "test2.jpg",
            category: "Finance",
            location: "New York"
        )
        
        // First load
        mockService.mockStartupDetail = mockStartup1
        sut.send(event: .onAppear)
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(sut.startupItem?.title, "Test Startup 1")
        
        // Second load with different data
        mockService.mockStartupDetail = mockStartup2
        sut.send(event: .onAppear)
        try await Task.sleep(nanoseconds: 500_000_000)
    
        XCTAssertEqual(sut.startupItem?.title, "Test Startup 2")
        XCTAssertEqual(mockService.getStartupCallCount, 2)
    }
}
