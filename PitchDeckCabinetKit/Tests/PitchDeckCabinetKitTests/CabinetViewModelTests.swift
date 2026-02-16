//
//  CabinetViewModelTests.swift
//  PitchDeckCabinetKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import XCTest
import Combine
import PitchDeckCabinetApiKit
@testable import PitchDeckCabinetKit
@testable import PitchDeckMainApiKit
@testable import PitchDeckAuthApiKit

@MainActor
final class CabinetViewModelTests: XCTestCase {
    
    var sut: CabinetViewModel!
    var mockStartupService: MockStartupService!
    var mockCabinetService: MockCabinetService!
    var mockAuthService: MockAuthService!
    
    override func setUp() async throws {
        mockStartupService = MockStartupService()
        mockCabinetService = MockCabinetService()
        mockAuthService = MockAuthService()
        sut = CabinetViewModel(
            cabinetService: mockCabinetService,
            startupService: mockStartupService,
            authService: mockAuthService
        )
    }
    
    override func tearDown() async throws {
        mockStartupService.reset()
        mockCabinetService.reset()
        mockAuthService.reset()
        sut = nil
        mockStartupService = nil
        mockCabinetService = nil
        mockAuthService = nil
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization_setsDefaultValues() {
        XCTAssertNil(sut.userProfile)
        XCTAssertTrue(sut.userStartups.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.didLogout)
    }
    
    // MARK: - Load User Profile Tests
    
    func testLoadUserProfile_loadsSuccessfully() async throws {
        let mockProfile = UserProfileData(
            firstName: "Test",
            lastName: "User",
            email: "test@example.com"
        )
        mockCabinetService.mockProfile = mockProfile
        
        sut.send(event: .loadUserProfile)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(sut.userProfile?.firstName, mockProfile.firstName)
        XCTAssertEqual(sut.userProfile?.email, mockProfile.email)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(mockCabinetService.getUserProfileCallCount, 1)
    }
    
    func testLoadUserProfile_handlesError() async throws {
        mockCabinetService.shouldFailGetProfile = true
        mockCabinetService.errorToThrow = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Profile not found"])
        
        sut.send(event: .loadUserProfile)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertNil(sut.userProfile)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.errorMessage, "Profile not found")
        XCTAssertEqual(mockCabinetService.getUserProfileCallCount, 1)
    }
    
    // MARK: - Load User Startups Tests
    
    func testLoadUserStartups_loadsSuccessfully() async throws {
        let mockStartups = MockStartupService.createMockStartupItems(count: 3)
        let mockPageInfo = MockStartupService.createMockPageInfo(page: 1, pageSize: 10, total: 3)
        
        mockStartupService.mockStartups = mockStartups
        mockStartupService.mockPageInfo = mockPageInfo
        
        sut.send(event: .loadUserStartups)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(sut.userStartups.count, 3)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(mockStartupService.getStartupsCallCount, 1)
    }
    
    func testLoadUserStartups_handlesError() async throws {
        mockStartupService.shouldFailGetStartups = true
        mockStartupService.errorToThrow = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Startups not found"])
        
        sut.send(event: .loadUserStartups)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertTrue(sut.userStartups.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.errorMessage, "Startups not found")
        XCTAssertEqual(mockStartupService.getStartupsCallCount, 1)
    }
    
    // MARK: - Load All Data Tests
    
    func testLoadAllData_loadsSuccessfully() async throws {
        let mockProfile = UserProfileData(
            firstName: "Test",
            lastName: "User",
            email: "test@example.com"
        )
        let mockStartups = MockStartupService.createMockStartupItems(count: 3)
        let mockPageInfo = MockStartupService.createMockPageInfo(page: 1, pageSize: 10, total: 3)
        
        mockCabinetService.mockProfile = mockProfile
        mockStartupService.mockStartups = mockStartups
        mockStartupService.mockPageInfo = mockPageInfo
        
        sut.send(event: .loadAllData)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(sut.userProfile?.firstName, mockProfile.firstName)
        XCTAssertEqual(sut.userStartups.count, 3)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(mockCabinetService.getUserProfileCallCount, 1)
        XCTAssertEqual(mockStartupService.getStartupsCallCount, 1)
    }
    
    // MARK: - Refresh Tests
    
    func testRefreshStartups_refreshesSuccessfully() async throws {
        let mockStartups = MockStartupService.createMockStartupItems(count: 3)
        let mockPageInfo = MockStartupService.createMockPageInfo(page: 1, pageSize: 10, total: 3)
        
        mockStartupService.mockStartups = mockStartups
        mockStartupService.mockPageInfo = mockPageInfo
        
        sut.send(event: .refreshStartups)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(sut.userStartups.count, 3)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(mockStartupService.getStartupsCallCount, 1)
    }
    
    func testRefreshAll_refreshesSuccessfully() async throws {
        let mockProfile = UserProfileData(
            firstName: "Test",
            lastName: "User",
            email: "test@example.com"
        )
        let mockStartups = MockStartupService.createMockStartupItems(count: 3)
        let mockPageInfo = MockStartupService.createMockPageInfo(page: 1, pageSize: 10, total: 3)
        
        mockCabinetService.mockProfile = mockProfile
        mockStartupService.mockStartups = mockStartups
        mockStartupService.mockPageInfo = mockPageInfo
        
        sut.send(event: .refreshAll)
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(sut.userProfile?.firstName, mockProfile.firstName)
        XCTAssertEqual(sut.userStartups.count, 3)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(mockCabinetService.getUserProfileCallCount, 1)
        XCTAssertEqual(mockStartupService.getStartupsCallCount, 1)
    }
    
    // MARK: - Logout Tests
    
    func testLogout_performsCorrectly() async throws {
        sut.send(event: .logout)
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertTrue(sut.didLogout)
        XCTAssertNil(sut.userProfile)
        XCTAssertTrue(sut.userStartups.isEmpty)
        XCTAssertEqual(mockAuthService.logoutCallCount, 1)
    }
}
