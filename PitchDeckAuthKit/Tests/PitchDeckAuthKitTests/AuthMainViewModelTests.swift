//
//  AuthMainViewModelTests.swift
//  PitchDeckAuthKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import XCTest
import Combine
@testable import PitchDeckAuthKit
@testable import PitchDeckAuthApiKit

@MainActor
final class AuthMainViewModelTests: XCTestCase {
    
    var sut: AuthMainViewModel!
    var mockAuthService: MockAuthService!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        sut = AuthMainViewModel(authService: mockAuthService)
    }
    
    override func tearDown() {
        sut = nil
        mockAuthService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState_isCorrect() {
        XCTAssertTrue(sut.email.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.didAuthorize)
        XCTAssertNil(sut.emailError)
        XCTAssertFalse(sut.isLoginEnabled)
    }
    
    // MARK: - Email Validation Tests
    
    func testEmailValidation_emptyEmail() async {
        sut.send(event: .emailChanged(""))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertNil(sut.emailError)
        XCTAssertFalse(sut.isLoginEnabled)
    }
    
    func testEmailValidation_invalidEmail() async {
        let invalidEmails = ["invalid", "test@", "@example.com", "test.example.com"]
        
        for email in invalidEmails {
            sut.send(event: .emailChanged(email))
            
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            } catch {
                
            }
            
            XCTAssertEqual(sut.emailError, "Wrong email format")
        }
    }
    
    func testEmailValidation_validEmail() async {
        let validEmails = ["test@example.com", "user.name@domain.co.uk", "user+tag@example.org"]
        
        for email in validEmails {
            sut.send(event: .emailChanged(email))
            
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            } catch {
                
            }
            
            XCTAssertNil(sut.emailError)
            XCTAssertTrue(sut.isLoginEnabled)
        }
    }
    
    // MARK: - Login Tests
    
    func testLogin_withEmptyEmail_setsError() async {
        let mockPresenter = UIViewController()
        
        sut.send(event: .loginTapped(presenter: mockPresenter))
        
        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.emailError, "Email cannot be empty")
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(mockAuthService.authorizeCallCount, 0)
    }
    
    func testLogin_withInvalidEmail_setsError() async {
        let mockPresenter = UIViewController()
        sut.send(event: .emailChanged("invalid-email"))
        
        sut.send(event: .loginTapped(presenter: mockPresenter))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.emailError, "Wrong email format")
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.didAuthorize)
        XCTAssertEqual(mockAuthService.authorizeCallCount, 0)
    }
    
    func testLogin_withValidCredentials_success() async {
        let mockPresenter = UIViewController()
        mockAuthService.shouldSucceed = true
        mockAuthService.mockTokens = AuthTokens(
            accessToken: "mock-access-token",
            idToken: "mock-id-token",
            refreshToken: "mock-refresh-token"
        )
        mockAuthService.mockProfile = UserProfile(
            id: "user-123",
            email: "test@example.com",
            name: "Test User"
        )
        
        sut.send(event: .emailChanged("test@example.com"))
        sut.send(event: .loginTapped(presenter: mockPresenter))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertNil(sut.emailError)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.didAuthorize)
        XCTAssertEqual(mockAuthService.authorizeCallCount, 1)
    }
    
    func testLogin_withNetworkError_setsErrorMessage() async {
        let mockPresenter = UIViewController()
        mockAuthService.shouldSucceed = false
        mockAuthService.errorToThrow = NSError(
            domain: "NetworkError",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Network timeout"]
        )
        
        sut.send(event: .emailChanged("test@example.com"))
        sut.send(event: .loginTapped(presenter: mockPresenter))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertNil(sut.emailError)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.didAuthorize)
        XCTAssertEqual(sut.errorMessage, "Network timeout")
        XCTAssertEqual(mockAuthService.authorizeCallCount, 1)
    }
    
    // MARK: - Logout Tests
    
    func testLogout_clearsState() async {
        mockAuthService.isAuthorized = true
        mockAuthService.accessToken = "test-token"
        
        sut.send(event: .logoutTapped)
        
        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch {
            
        }
        
        XCTAssertFalse(sut.didAuthorize)
        XCTAssertEqual(mockAuthService.logoutCallCount, 1)
    }
    
    // MARK: - OnAppear Tests
    
    func testOnAppear_clearsErrors() async {
        sut.send(event: .emailChanged("test@example.com"))
        let mockPresenter = UIViewController()
        sut.send(event: .loginTapped(presenter: mockPresenter))
        
        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch {
            
        }
        
        sut.send(event: .onAppear)
        
        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch {
            
        }
        
        XCTAssertNil(sut.emailError)
        XCTAssertNil(sut.errorMessage)
    }
}
