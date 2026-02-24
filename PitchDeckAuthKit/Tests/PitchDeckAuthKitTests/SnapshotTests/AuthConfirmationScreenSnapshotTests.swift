//
//  AuthConfirmationScreenSnapshotTests.swift
//  PitchDeckAuthKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import PitchDeckAuthKit

@MainActor
final class AuthConfirmationScreenSnapshotTests: XCTestCase {
    
    func testAuthConfirmationScreen_empty_snapshot() {
        let viewModel = AuthConfirmationViewModel(email: "test@example.com")
        let view = AuthConfirmationScreen(
            email: "test@example.com",
            onConfirmationSuccess: {}
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "AuthConfirmationScreen_empty"
        )
    }
    
    func testAuthConfirmationScreen_withPartialCode_snapshot() {
        let viewModel = AuthConfirmationViewModel(email: "test@example.com")
        viewModel.confirmationCode = "123"
        viewModel.activeIndex = 2
        let view = AuthConfirmationScreen(
            email: "test@example.com",
            onConfirmationSuccess: {}
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "AuthConfirmationScreen_with_partial_code"
        )
    }
    
    func testAuthConfirmationScreen_withFullCode_snapshot() {
        let viewModel = AuthConfirmationViewModel(email: "test@example.com")
        viewModel.confirmationCode = "123456"
        viewModel.activeIndex = 5
        let view = AuthConfirmationScreen(
            email: "test@example.com",
            onConfirmationSuccess: {}
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "AuthConfirmationScreen_with_full_code"
        )
    }
    
    func testAuthConfirmationScreen_withCodeError_snapshot() {
        let viewModel = AuthConfirmationViewModel(email: "test@example.com")
        viewModel.confirmationCode = "123"
        viewModel.codeError = "Invalid code format"
        let view = AuthConfirmationScreen(
            email: "test@example.com",
            onConfirmationSuccess: {}
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "AuthConfirmationScreen_with_code_error"
        )
    }
    
    func testAuthConfirmationScreen_confirmed_snapshot() {
        let viewModel = AuthConfirmationViewModel(email: "test@example.com")
        viewModel.didConfirm = true
        let view = AuthConfirmationScreen(
            email: "test@example.com",
            onConfirmationSuccess: {}
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "AuthConfirmationScreen_confirmed"
        )
    }
    
    func testAuthConfirmationScreen_loading_snapshot() {
        let viewModel = AuthConfirmationViewModel(email: "test@example.com")
        viewModel.isLoading = true
        let view = AuthConfirmationScreen(
            email: "test@example.com",
            onConfirmationSuccess: {}
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "AuthConfirmationScreen_loading"
        )
    }
}
