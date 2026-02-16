//
//  AuthRegistrationViewModelTests.swift
//  PitchDeckAuthKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import XCTest
import Combine
@testable import PitchDeckAuthKit
@testable import PitchDeckAuthApiKit

@MainActor
final class AuthRegistrationViewModelTests: XCTestCase {
    
    var sut: AuthRegistrationViewModel!
    var mockProfileService: MockProfileService!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockProfileService = MockProfileService()
        sut = AuthRegistrationViewModel(profileService: mockProfileService)
    }
    
    override func tearDown() {
        sut = nil
        mockProfileService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState_isCorrect() {
        XCTAssertTrue(sut.email.isEmpty)
        XCTAssertTrue(sut.firstName.isEmpty)
        XCTAssertTrue(sut.lastName.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.didRegister)
        XCTAssertNil(sut.emailError)
        XCTAssertNil(sut.firstNameError)
        XCTAssertNil(sut.lastNameError)
        XCTAssertFalse(sut.isRegistrationEnabled)
    }
    
    // MARK: - Email Validation Tests
    
    func testEmailValidation_emptyEmail() async {
        sut.send(event: .emailChanged(""))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
        
        }
        
        XCTAssertNil(sut.emailError)
        XCTAssertFalse(sut.isRegistrationEnabled)
    }
    
    func testEmailValidation_direct() async {
        sut.send(event: .emailChanged("invalid-email"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
        }
        
        XCTAssertEqual(sut.emailError, "Wrong email format")
        
        sut.send(event: .emailChanged("test@example.com"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {

        }
        
        XCTAssertNil(sut.emailError)
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
            
        }
    }
    
    // MARK: - First Name Validation Tests
    
    func testFirstNameValidation_emptyName() async {
        sut.send(event: .firstNameChanged(""))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertNil(sut.firstNameError)
        XCTAssertFalse(sut.isRegistrationEnabled)
    }
    
    func testFirstNameValidation_validName() async {
        let validNames = ["John", "Mary", "Dan"]
        
        for name in validNames {
            sut.send(event: .firstNameChanged(name))
            
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            } catch {
                
            }
            
            XCTAssertNil(sut.firstNameError)
        }
    }
    
    // MARK: - Last Name Validation Tests
    
    func testLastNameValidation_emptyName() async {
        sut.send(event: .lastNameChanged(""))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertNil(sut.lastNameError)
        XCTAssertFalse(sut.isRegistrationEnabled)
    }
    
    func testLastNameValidation_validName() async {
        let validNames = ["Doe", "Smith", "Dan"]
        
        for name in validNames {
            sut.send(event: .lastNameChanged(name))
            
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            } catch {
                
            }
            
            XCTAssertNil(sut.lastNameError)
        }
    }
    
    func testIsRegistrationEnabled_allFieldsFilled() async {
        sut.send(event: .emailChanged("test@example.com"))
        sut.send(event: .firstNameChanged("John"))
        sut.send(event: .lastNameChanged("Doe"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertNil(sut.emailError)
        XCTAssertNil(sut.firstNameError)
        XCTAssertNil(sut.lastNameError)
        XCTAssertTrue(sut.isRegistrationEnabled)
    }
    
    // MARK: - Registration Tests
    
    func testRegistration_withEmptyEmail_setsError() async {
        sut.send(event: .emailChanged("test@example.com"))
        sut.send(event: .firstNameChanged("John"))
        sut.send(event: .lastNameChanged("Doe"))
        sut.send(event: .emailChanged(""))
        
        sut.send(event: .registerTapped)
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
        
        }
        
        XCTAssertEqual(sut.emailError, "Email cannot be empty")
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.didRegister)
        XCTAssertEqual(mockProfileService.registerUserCallCount, 0)
    }
    
    func testRegistration_withInvalidEmail_setsError() async {
        sut.send(event: .emailChanged("invalid-email"))
        sut.send(event: .firstNameChanged("John"))
        sut.send(event: .lastNameChanged("Doe"))
        
        sut.send(event: .registerTapped)
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.emailError, "Wrong email format")
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.didRegister)
        XCTAssertEqual(mockProfileService.registerUserCallCount, 0)
    }
    
    func testRegistration_withEmptyFirstName_setsError() async {
        sut.send(event: .emailChanged("test@example.com"))
        sut.send(event: .firstNameChanged("John"))
        sut.send(event: .lastNameChanged("Doe"))
        sut.send(event: .firstNameChanged(""))
        
        sut.send(event: .registerTapped)
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.firstNameError, "First name cannot be empty")
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.didRegister)
        XCTAssertEqual(mockProfileService.registerUserCallCount, 0)
    }
    
    func testRegistration_withEmptyLastName_setsError() async {
        sut.send(event: .emailChanged("test@example.com"))
        sut.send(event: .firstNameChanged("John"))
        sut.send(event: .lastNameChanged("Doe"))
        sut.send(event: .lastNameChanged(""))
        
        sut.send(event: .registerTapped)
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000) // Increased wait time
        } catch {
            
        }
        
        XCTAssertEqual(sut.lastNameError, "Last name cannot be empty")
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.didRegister)
        XCTAssertEqual(mockProfileService.registerUserCallCount, 0)
    }
    
    func testRegistration_withValidData_success() async {
        mockProfileService.shouldSucceed = true
        
        sut.send(event: .emailChanged("newuser@example.com"))
        sut.send(event: .firstNameChanged("New"))
        sut.send(event: .lastNameChanged("User"))
        
        sut.send(event: .registerTapped)
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertNil(sut.emailError)
        XCTAssertNil(sut.firstNameError)
        XCTAssertNil(sut.lastNameError)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.didRegister)
        XCTAssertEqual(mockProfileService.registerUserCallCount, 1)
    }
    
    func testRegistration_withNetworkError_setsErrorMessage() async {
        mockProfileService.shouldSucceed = false
        mockProfileService.errorToThrow = NSError(
            domain: "NetworkError",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Registration failed"]
        )
        
        sut.send(event: .emailChanged("newuser@example.com"))
        sut.send(event: .firstNameChanged("New"))
        sut.send(event: .lastNameChanged("User"))
        
        sut.send(event: .registerTapped)
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertNil(sut.emailError)
        XCTAssertNil(sut.firstNameError)
        XCTAssertNil(sut.lastNameError)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.didRegister)
        XCTAssertEqual(sut.errorMessage, "Registration failed")
        XCTAssertEqual(mockProfileService.registerUserCallCount, 1)
    }
    
    // MARK: - OnAppear Tests
    
    func testOnAppear_clearsState() async {
        sut.send(event: .emailChanged("test@example.com"))
        sut.send(event: .firstNameChanged("Test"))
        sut.send(event: .lastNameChanged("User"))
        
        sut.send(event: .onAppear)
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertTrue(sut.email.isEmpty)
        XCTAssertTrue(sut.firstName.isEmpty)
        XCTAssertTrue(sut.lastName.isEmpty)
        XCTAssertNil(sut.errorMessage)
        XCTAssertNil(sut.emailError)
        XCTAssertNil(sut.firstNameError)
        XCTAssertNil(sut.lastNameError)
        XCTAssertFalse(sut.isLoading)
    }
}
