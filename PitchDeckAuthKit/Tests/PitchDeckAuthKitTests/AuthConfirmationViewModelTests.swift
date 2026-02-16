//
//  AuthConfirmationViewModelTests.swift
//  PitchDeckAuthKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import XCTest
import Combine
@testable import PitchDeckAuthKit

@MainActor
final class AuthConfirmationViewModelTests: XCTestCase {
    
    var sut: AuthConfirmationViewModel!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        sut = AuthConfirmationViewModel(email: "test@example.com")
    }
    
    override func tearDown() {
        sut = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState_isCorrect() {
        XCTAssertTrue(sut.confirmationCode.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertNil(sut.codeError)
        XCTAssertFalse(sut.didConfirm)
        XCTAssertEqual(sut.activeIndex, 0)
        XCTAssertFalse(sut.isConfirmationEnabled)
    }
    
    // MARK: - Code Input Tests
    
    func testDigitAdded_multipleDigits() async {
        sut.send(event: .digitAdded("1"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        sut.send(event: .digitAdded("2"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        sut.send(event: .digitAdded("3"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.confirmationCode, "123")
        XCTAssertEqual(sut.activeIndex, 3)
        XCTAssertFalse(sut.isConfirmationEnabled)
    }
    
    func testDigitAdded_exceedsLimit() async {
        for i in 1...6 {
            sut.send(event: .digitAdded("\(i)"))
            
            do {
                try await Task.sleep(nanoseconds: 100_000_000)
            } catch {
                
            }
        }
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.confirmationCode, "123456")
        XCTAssertEqual(sut.activeIndex, 5)
        XCTAssertTrue(sut.isConfirmationEnabled)
        
        sut.send(event: .digitAdded("7"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.confirmationCode, "123456")
        XCTAssertEqual(sut.activeIndex, 5)
    }
    
    func testDigitRemoved_removesLastDigit() async {
        sut.send(event: .digitAdded("1"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        sut.send(event: .digitAdded("2"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        sut.send(event: .digitAdded("3"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.confirmationCode, "123")
        XCTAssertEqual(sut.activeIndex, 3)
        
        sut.send(event: .digitRemoved)
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.confirmationCode, "12")
        XCTAssertEqual(sut.activeIndex, 2)
    }
    
    func testDigitRemoved_emptyCode() async {
        sut.send(event: .digitAdded("1"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.confirmationCode, "1")
        XCTAssertEqual(sut.activeIndex, 1)
        
        sut.send(event: .digitRemoved)
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.confirmationCode, "")
        XCTAssertEqual(sut.activeIndex, 0)
    }
    
    func testSetActiveIndex_updatesIndex() async {
        sut.send(event: .digitAdded("1"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        sut.send(event: .digitAdded("2"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        sut.send(event: .digitAdded("3"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.activeIndex, 3)
        
        sut.send(event: .setActiveIndex(0))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.activeIndex, 0)
    }
    
    func testUpdateCode_updatesCodeAndIndex() async {
        sut.send(event: .digitAdded("1"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        sut.send(event: .digitAdded("2"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.confirmationCode, "12")
        XCTAssertEqual(sut.activeIndex, 2)
        
        sut.send(event: .updateCode("123456"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.confirmationCode, "123456")
        XCTAssertEqual(sut.activeIndex, 5)
    }
    
    func testUpdateCode_shorterCode() async {
        sut.send(event: .digitAdded("1"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        sut.send(event: .digitAdded("2"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        sut.send(event: .digitAdded("3"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        sut.send(event: .digitAdded("4"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.confirmationCode, "1234")
        XCTAssertEqual(sut.activeIndex, 4)
        
        sut.send(event: .updateCode("12"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.confirmationCode, "12")
        XCTAssertEqual(sut.activeIndex, 2)
    }
    
    // MARK: - Confirmation Tests
    
    func testConfirmCode_withInvalidCode_setsError() async {
        for i in 1...5 {
            sut.send(event: .digitAdded("\(i)"))
        }
        
        sut.send(event: .confirmCodeTapped)
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.codeError, "Confirmation code must be 6 digits")
        XCTAssertFalse(sut.didConfirm)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testConfirmCode_withValidCode_success() async {
        sut.send(event: .updateCode("123456"))
        sut.send(event: .confirmCodeTapped)
        
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
        } catch {
            
        }
        
        XCTAssertNil(sut.codeError)
        XCTAssertTrue(sut.didConfirm)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testConfirmCode_withWrongCode_setsError() async {
        sut.send(event: .updateCode("999999"))
        
        sut.send(event: .confirmCodeTapped)
        
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
        } catch {
            
        }
        
        XCTAssertEqual(sut.codeError, "Invalid confirmation code")
        XCTAssertFalse(sut.didConfirm)
        XCTAssertFalse(sut.isLoading)
    }
    
    // MARK: - OnAppear Tests
    
    func testOnAppear_clearsState() async {
        sut.send(event: .digitAdded("1"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        sut.send(event: .digitAdded("2"))
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        sut.send(event: .onAppear)
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
        } catch {
            
        }
        
        XCTAssertTrue(sut.confirmationCode.isEmpty)
        XCTAssertEqual(sut.activeIndex, 0)
        XCTAssertNil(sut.codeError)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.didConfirm)
        XCTAssertFalse(sut.isConfirmationEnabled)
    }
}
