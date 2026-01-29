//
//  AuthRegistrationViewModel.swift
//  PitchDeckAuthKit
//
//  Created by Anton Redkozubov on 21.01.2026.
//

import Foundation
import PitchDeckCoreKit
import PitchDeckAuthApiKit

@MainActor
public final class AuthRegistrationViewModel: ObservableObject {
    
    // MARK: - Published properties
    
    @Published public var email: String = ""
    @Published public var firstName: String = ""
    @Published public var lastName: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    @Published public var didRegister: Bool = false
    @Published public var emailError: String? = nil
    @Published public var firstNameError: String? = nil
    @Published public var lastNameError: String? = nil
    
    public var isRegistrationEnabled: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        emailError == nil &&
        firstNameError == nil &&
        lastNameError == nil
    }
    
    // MARK: - Private properties
    
    private let profileService: ProfileService
    
    // MARK: - Init
    
    public init(profileService: ProfileService = ProfileServiceImpl()) {
        self.profileService = profileService
    }
    
    // MARK: - Public methods
    
    public func register() {
        Task { @MainActor in
            await performRegistration()
        }
    }
    
    // MARK: - Private methods
    
    private func performRegistration() async {
        errorMessage = nil
        clearValidationErrors()
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedEmail.isEmpty {
            emailError = "Email cannot be empty"
            return
        }
        
        if !isValidEmail(trimmedEmail) {
            emailError = "Wrong email format"
            return
        }
        
        if trimmedFirstName.isEmpty {
            firstNameError = "First name cannot be empty"
            return
        }
        
        if trimmedLastName.isEmpty {
            lastNameError = "Last name cannot be empty"
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = ProfileRegistrationRequest(
                email: trimmedEmail,
                firstName: trimmedFirstName,
                lastName: trimmedLastName
            )
            try await profileService.registerUser(request: request)
            didRegister = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func clearValidationErrors() {
        emailError = nil
        firstNameError = nil
        lastNameError = nil
    }
}
