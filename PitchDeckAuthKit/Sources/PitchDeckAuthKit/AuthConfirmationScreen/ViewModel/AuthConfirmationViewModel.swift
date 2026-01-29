//
//  AuthConfirmationViewModel.swift
//  PitchDeckAuthKit
//
//  Created by Anton Redkozubov on 21.01.2026.
//

import Foundation
import PitchDeckCoreKit
import PitchDeckAuthApiKit

@MainActor
public final class AuthConfirmationViewModel: ObservableObject {
    
    // MARK: - Published properties
    
    @Published public var confirmationCode: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    @Published public var codeError: String? = nil
    @Published public var didConfirm: Bool = false
    
    public var isConfirmationEnabled: Bool {
        !confirmationCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        confirmationCode.trimmingCharacters(in: .whitespacesAndNewlines).count == 6 &&
        codeError == nil
    }
    
    // MARK: - Private properties
    
    private(set) var email: String
    
    // TODO: Add service for code confirmation 
    
    // MARK: - Init
    
    public init(email: String) {
        self.email = email
    }
    
    // MARK: - Public methods
    
    public func confirmCode() {
        Task { @MainActor in
            await performConfirmation()
        }
    }
    
    // MARK: - Private methods
    
    private func performConfirmation() async {
        isLoading = true
        errorMessage = nil
        codeError = nil
        
        let trimmedCode = confirmationCode.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard trimmedCode.count == 6 else {
            codeError = "Confirmation code must be 6 digits"
            isLoading = false
            return
        }
        
        // TODO: Implement actual API call for code confirmation
        do {
            try await Task.sleep(nanoseconds: 1_500_000_000)
            if trimmedCode == "123456" {
                didConfirm = true
            } else {
                codeError = "Invalid confirmation code"
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    public func updateConfirmationCode(_ code: String) {
        confirmationCode = String(code.prefix(6))
        codeError = nil
        errorMessage = nil
    }
}
