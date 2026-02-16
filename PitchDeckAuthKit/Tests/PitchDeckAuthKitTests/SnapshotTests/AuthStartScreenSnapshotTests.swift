//
//  AuthStartScreenSnapshotTests.swift
//  PitchDeckAuthKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import PitchDeckAuthKit

@MainActor
final class AuthStartScreenSnapshotTests: XCTestCase {
    
    func testAuthStartScreen_empty_snapshot() {
        let view = AuthStartScreen(
            onLogin: {},
            onRegistration: {}
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "AuthStartScreen_empty"
        )
    }
    
    func testAuthStartScreen_withEmail_snapshot() {
        let viewModel = AuthMainViewModel(authService: MockAuthService())
        viewModel.email = "test@example.com"
        let view = AuthStartScreen(
            onLogin: {},
            onRegistration: {}
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "AuthStartScreen_with_email"
        )
    }
    
    func testAuthStartScreen_withError_snapshot() {
        let viewModel = AuthMainViewModel(authService: MockAuthService())
        viewModel.errorMessage = "Invalid credentials"
        let view = AuthStartScreen(
            onLogin: {},
            onRegistration: {}
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "AuthStartScreen_with_error"
        )
    }
    
    func testAuthStartScreen_loading_snapshot() {
        let viewModel = AuthMainViewModel(authService: MockAuthService())
        viewModel.isLoading = true
        let view = AuthStartScreen(
            onLogin: {},
            onRegistration: {}
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "AuthStartScreen_loading"
        )
    }
    
    func testAuthStartScreen_authorized_snapshot() {
        let viewModel = AuthMainViewModel(authService: MockAuthService())
        viewModel.didAuthorize = true
        let view = AuthStartScreen(
            onLogin: {},
            onRegistration: {}
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "AuthStartScreen_authorized"
        )
    }
}
