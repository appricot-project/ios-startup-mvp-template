//
//  AuthMainScreenSnapshotTests.swift
//  PitchDeckAuthKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import PitchDeckAuthKit

@MainActor
final class AuthMainScreenSnapshotTests: XCTestCase {
    
    func testAuthMainScreen_empty_snapshot() {
        let viewModel = AuthMainViewModel(authService: MockAuthService())
        let view = AuthMainScreen(
            viewModel: viewModel,
            onSelectConfirmation: { _ in },
            onAuthorizationCompleted: nil
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "AuthMainScreen_empty"
        )
    }
    
    func testAuthMainScreen_withEmail_snapshot() {
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
            named: "AuthMainScreen_with_email"
        )
    }
    
    func testAuthMainScreen_withEmailError_snapshot() {
        let viewModel = AuthMainViewModel(authService: MockAuthService())
        viewModel.email = "test@example.com"
        viewModel.emailError = "Wrong email format"
        let view = AuthMainScreen(
            viewModel: viewModel,
            onSelectConfirmation: { _ in },
            onAuthorizationCompleted: nil
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "AuthMainScreen_with_email_error"
        )
    }
    
    func testAuthMainScreen_loading_snapshot() {
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
            named: "AuthMainScreen_loading"
        )
    }
    
    func testAuthMainScreen_authorized_snapshot() {
        let viewModel = AuthMainViewModel(authService: MockAuthService())
        viewModel.didAuthorize = true
        let view = AuthMainScreen(
            viewModel: viewModel,
            onSelectConfirmation: { _ in },
            onAuthorizationCompleted: nil
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "AuthMainScreen_authorized"
        )
    }
}
