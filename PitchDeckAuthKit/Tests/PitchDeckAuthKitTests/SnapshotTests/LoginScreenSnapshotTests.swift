//
//  LoginScreenSnapshotTests.swift
//  PitchDeckAuthKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import PitchDeckAuthKit

@MainActor
final class LoginScreenSnapshotTests: XCTestCase {
    
    func testLoginScreen_empty_snapshot() {
        let viewModel = AuthMainViewModel(authService: MockAuthService())
        let view = AuthMainScreen(
            viewModel: viewModel,
            onSelectConfirmation: { _ in },
            onAuthorizationCompleted: nil
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "LoginScreen_empty"
        )
    }
    
    func testLoginScreen_withEmail_snapshot() {
        let viewModel = AuthMainViewModel(authService: MockAuthService())
        viewModel.email = "test@example.com"
        let view = AuthMainScreen(
            viewModel: viewModel,
            onSelectConfirmation: { _ in },
            onAuthorizationCompleted: nil
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "LoginScreen_with_email"
        )
    }
    
    func testLoginScreen_withPassword_snapshot() {
        let viewModel = AuthMainViewModel(authService: MockAuthService())
        viewModel.email = "test@example.com"
        let view = AuthMainScreen(
            viewModel: viewModel,
            onSelectConfirmation: { _ in },
            onAuthorizationCompleted: nil
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "LoginScreen_with_password"
        )
    }
    
    func testLoginScreen_withError_snapshot() {
        let viewModel = AuthMainViewModel(authService: MockAuthService())
        viewModel.errorMessage = "Invalid email or password"
        let view = AuthMainScreen(
            viewModel: viewModel,
            onSelectConfirmation: { _ in },
            onAuthorizationCompleted: nil
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "LoginScreen_with_error"
        )
    }
    
    func testLoginScreen_loading_snapshot() {
        let viewModel = AuthMainViewModel(authService: MockAuthService())
        viewModel.isLoading = true
        let view = AuthMainScreen(
            viewModel: viewModel,
            onSelectConfirmation: { _ in },
            onAuthorizationCompleted: nil
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "LoginScreen_loading"
        )
    }
    
    func testLoginScreen_disabled_snapshot() {
        let viewModel = AuthMainViewModel(authService: MockAuthService())
        viewModel.email = ""
        let view = AuthMainScreen(
            viewModel: viewModel,
            onSelectConfirmation: { _ in },
            onAuthorizationCompleted: nil
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "LoginScreen_disabled"
        )
    }
}
