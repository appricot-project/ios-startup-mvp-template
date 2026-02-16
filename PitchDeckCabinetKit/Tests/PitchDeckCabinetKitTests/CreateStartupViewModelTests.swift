//
//  CreateStartupViewModelTests.swift
//  PitchDeckCabinetKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import XCTest
@testable import PitchDeckCabinetKit
@testable import PitchDeckMainApiKit

@MainActor
final class CreateStartupViewModelTests: XCTestCase {
    
    var sut: CreateStartupViewModel!
    var mockService: MockStartupService!
    var mockCabinetService: MockCabinetService!
    
    override func setUp() async throws {
        mockService = MockStartupService()
        mockCabinetService = MockCabinetService()
        sut = CreateStartupViewModel(
            startupService: mockService,
            cabinetService: mockCabinetService
        )
    }
    
    override func tearDown() async throws {
        mockService.reset()
        mockCabinetService.reset()
        sut = nil
        mockService = nil
        mockCabinetService = nil
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization_setsDefaultValues() {
        XCTAssertTrue(sut.ownerEmail.isEmpty)
        XCTAssertTrue(sut.title.isEmpty)
        XCTAssertTrue(sut.description.isEmpty)
        XCTAssertTrue(sut.location.isEmpty)
        XCTAssertNil(sut.selectedCategoryId)
        XCTAssertTrue(sut.categories.isEmpty)
        XCTAssertNil(sut.selectedImageData)
        XCTAssertFalse(sut.isCreating)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isCreateEnabled)
    }
    
    // MARK: - Form Validation Tests
    
    func testFormValidation_allFieldsValid_returnsTrue() {
        sut.ownerEmail = "test@example.com"
        sut.title = "Test Startup"
        sut.description = "Test Description"
        sut.location = "San Francisco"
        sut.selectedCategoryId = "1"
        
        XCTAssertTrue(sut.isCreateEnabled)
    }
    
    func testFormValidation_emptyOwnerEmail_returnsFalse() {
        sut.ownerEmail = ""
        sut.title = "Test Startup"
        sut.description = "Test Description"
        sut.location = "San Francisco"
        sut.selectedCategoryId = "1"
        
        XCTAssertFalse(sut.isCreateEnabled)
    }
    
    func testFormValidation_emptyTitle_returnsFalse() {
        sut.ownerEmail = "test@example.com"
        sut.title = ""
        sut.description = "Test Description"
        sut.location = "San Francisco"
        sut.selectedCategoryId = "1"
        
        XCTAssertFalse(sut.isCreateEnabled)
    }
    
    func testFormValidation_emptyDescription_returnsFalse() {
        sut.ownerEmail = "test@example.com"
        sut.title = "Test Startup"
        sut.description = ""
        sut.location = "San Francisco"
        sut.selectedCategoryId = "1"
        
        XCTAssertFalse(sut.isCreateEnabled)
    }
    
    func testFormValidation_emptyLocation_returnsFalse() {
        sut.ownerEmail = "test@example.com"
        sut.title = "Test Startup"
        sut.description = "Test Description"
        sut.location = ""
        sut.selectedCategoryId = "1"
        
        XCTAssertFalse(sut.isCreateEnabled)
    }
    
    func testFormValidation_emptySelectedCategoryId_returnsFalse() {
        sut.ownerEmail = "test@example.com"
        sut.title = "Test Startup"
        sut.description = "Test Description"
        sut.location = "San Francisco"
        sut.selectedCategoryId = nil
        
        XCTAssertFalse(sut.isCreateEnabled)
    }
    
    // MARK: - Image Selection Tests
    
    func testSelectImage_setsImageData() async {
        let testData = Data([0x01, 0x02, 0x03])
        
        sut.send(event: .selectImage(testData))
        
        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.selectedImageData, testData)
    }
    
    func testSelectImage_withEmptyData_doesNothing() async {
        let emptyData = Data()
        
        sut.send(event: .selectImage(emptyData))
        
        // Wait for async update
        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch {
            // Ignore sleep cancellation errors
        }
        
        XCTAssertEqual(sut.selectedImageData, emptyData)
    }
    
    // MARK: - Create Startup Tests
    
    func testOnCreate_createsStartupSuccessfully() async throws {
        sut.ownerEmail = "test@example.com"
        sut.title = "Test Startup"
        sut.description = "Test Description"
        sut.location = "San Francisco"
        sut.selectedCategoryId = "1"
        sut.selectedImageData = Data([0x01, 0x02, 0x03])
        
        sut.send(event: .createStartup)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertFalse(sut.isCreating)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(mockService.createStartupCallCount, 1)
        XCTAssertNotNil(mockService.lastCreateStartupRequest)
        XCTAssertEqual(mockService.lastCreateStartupRequest?.title, "Test Startup")
    }
    
    func testOnCreate_handlesError() async throws {
        sut.ownerEmail = "test@example.com"
        sut.title = "Test Startup"
        sut.description = "Test Description"
        sut.location = "San Francisco"
        sut.selectedCategoryId = "1"
        
        mockService.shouldFailCreateStartup = true
        mockService.errorToThrow = NSError(domain: "TestError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Creation failed"])
        
        sut.send(event: .createStartup)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertFalse(sut.isCreating)
        XCTAssertEqual(sut.errorMessage, "Creation failed")
        XCTAssertEqual(mockService.createStartupCallCount, 1)
    }
    
    func testOnCreate_setsLoadingStateCorrectly() async throws {
        sut.ownerEmail = "test@example.com"
        sut.title = "Test Startup"
        sut.description = "Test Description"
        sut.location = "San Francisco"
        sut.selectedCategoryId = "1"
        
        sut.send(event: .createStartup)
        
        XCTAssertNil(sut.errorMessage)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertFalse(sut.isCreating)
    }
    
    func testOnCreate_withInvalidForm_doesNotCallService() async throws {
        sut.ownerEmail = "" // Invalid form
        
        sut.send(event: .createStartup)
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertFalse(sut.isCreating)
        XCTAssertEqual(mockService.createStartupCallCount, 0)
    }
    
    // MARK: - Field Update Tests
    
    func testOnTitleChanged_updatesTitle() async {
        let newTitle = "New Title"
        
        sut.send(event: .titleChanged(newTitle))
        
        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.title, newTitle)
    }
    
    func testOnDescriptionChanged_updatesDescription() async {
        let newDescription = "New Description"
        
        sut.send(event: .descriptionChanged(newDescription))
        
        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.description, newDescription)
    }
    
    func testOnCategoryChanged_updatesCategory() async {
        let newCategory = "1"
        
        sut.send(event: .categoryChanged(newCategory))
        
        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.selectedCategoryId, newCategory)
    }
    
    func testOnLocationChanged_updatesLocation() async {
        let newLocation = "New Location"
        
        sut.send(event: .locationChanged(newLocation))
        
        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.location, newLocation)
    }
    
    func testOnOwnerEmailChanged_updatesOwnerEmail() async {
        let newOwnerEmail = "test@example.com"
        
        sut.send(event: .ownerEmailChanged(newOwnerEmail))
        
        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch {
        
        }
        
        XCTAssertEqual(sut.ownerEmail, newOwnerEmail)
    }
    
    // MARK: - Error Handling Tests
    
    func testOnCreate_withCancellationError_doesNotSetErrorMessage() async throws {
        sut.ownerEmail = "test@example.com"
        sut.title = "Test Startup"
        sut.description = "Test Description"
        sut.location = "San Francisco"
        sut.selectedCategoryId = "1"
        
        mockService.shouldFailCreateStartup = true
        mockService.errorToThrow = CancellationError()
        
        sut.send(event: .createStartup)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertFalse(sut.isCreating)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testOnCreate_withNetworkError_setsErrorMessage() async throws {
        sut.ownerEmail = "test@example.com"
        sut.title = "Test Startup"
        sut.description = "Test Description"
        sut.location = "San Francisco"
        sut.selectedCategoryId = "1"

        mockService.shouldFailCreateStartup = true
        mockService.errorToThrow = NSError(domain: "NetworkError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Network timeout"])

        sut.send(event: .createStartup)
        
        try await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertFalse(sut.isCreating)
        XCTAssertEqual(sut.errorMessage, "Network timeout")
    }
    
    // MARK: - Multiple Creation Tests
    
    func testMultipleOnCreate_calls_createsCorrectly() async throws {
        sut.ownerEmail = "test@example.com"
        sut.title = "Test Startup"
        sut.description = "Test Description"
        sut.location = "San Francisco"
        sut.selectedCategoryId = "1"
        
        // First creation
        sut.send(event: .createStartup)
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(mockService.createStartupCallCount, 1)
        
        // Second creation
        sut.send(event: .createStartup)
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(mockService.createStartupCallCount, 2)
    }
}
