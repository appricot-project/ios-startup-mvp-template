//
//  RegistrationScreenSnapshotTests.swift
//  PitchDeckAuthKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import PitchDeckAuthKit

@MainActor
final class RegistrationScreenSnapshotTests: XCTestCase {
    
    func testRegistrationScreen_empty_snapshot() {
        let viewModel = AuthRegistrationViewModel(profileService: MockProfileService())
        let view = AuthRegistrationScreen(
            viewModel: viewModel,
            onRegistered: { _ in }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "RegistrationScreen_empty"
        )
    }
    
    func testRegistrationScreen_withEmail_snapshot() {
        let viewModel = AuthRegistrationViewModel(profileService: MockProfileService())
        viewModel.email = "newuser@example.com"
        let view = AuthRegistrationScreen(
            viewModel: viewModel,
            onRegistered: { _ in }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "RegistrationScreen_with_email"
        )
    }
    
    func testRegistrationScreen_withNames_snapshot() {
        let viewModel = AuthRegistrationViewModel(profileService: MockProfileService())
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        let view = AuthRegistrationScreen(
            viewModel: viewModel,
            onRegistered: { _ in }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "RegistrationScreen_with_names"
        )
    }
    
    func testRegistrationScreen_withEmailError_snapshot() {
        let viewModel = AuthRegistrationViewModel(profileService: MockProfileService())
        viewModel.email = "test@example.com"
        viewModel.emailError = "Email already exists"
        let view = AuthRegistrationScreen(
            viewModel: viewModel,
            onRegistered: { _ in }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "RegistrationScreen_with_email_error"
        )
    }
    
    func testRegistrationScreen_withFirstNameError_snapshot() {
        let viewModel = AuthRegistrationViewModel(profileService: MockProfileService())
        viewModel.firstName = "John"
        viewModel.firstNameError = "First name cannot be empty"
        let view = AuthRegistrationScreen(
            viewModel: viewModel,
            onRegistered: { _ in }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "RegistrationScreen_with_first_name_error"
        )
    }
    
    func testRegistrationScreen_withLastNameError_snapshot() {
        let viewModel = AuthRegistrationViewModel(profileService: MockProfileService())
        viewModel.lastName = "Doe"
        viewModel.lastNameError = "Last name cannot be empty"
        let view = AuthRegistrationScreen(
            viewModel: viewModel,
            onRegistered: { _ in }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "RegistrationScreen_with_last_name_error"
        )
    }
    
    func testRegistrationScreen_loading_snapshot() {
        let viewModel = AuthRegistrationViewModel(profileService: MockProfileService())
        viewModel.isLoading = true
        let view = AuthRegistrationScreen(
            viewModel: viewModel,
            onRegistered: { _ in }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "RegistrationScreen_loading"
        )
    }
    
    func testRegistrationScreen_registered_snapshot() {
        let viewModel = AuthRegistrationViewModel(profileService: MockProfileService())
        viewModel.didRegister = true
        let view = AuthRegistrationScreen(
            viewModel: viewModel,
            onRegistered: { _ in }
        )
        
        assertSnapshot(
            of: view.snapshotController(),
            as: .image(precision: 0.95),
            named: "RegistrationScreen_registered"
        )
    }
}
