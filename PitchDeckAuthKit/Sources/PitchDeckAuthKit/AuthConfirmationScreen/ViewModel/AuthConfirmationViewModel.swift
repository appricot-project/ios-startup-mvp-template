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
    @Published public var activeIndex: Int = 0
    
    public var isConfirmationEnabled: Bool {
        confirmationCode.count == 6 && codeError == nil
    }
    
    // MARK: - Private properties
    
    private(set) var email: String
    
    // TODO: Add service for code confirmation 
    
    // MARK: - Init
    
    public init(email: String) {
        self.email = email
    }
    
    // MARK: - Event
    
    public enum Event {
        case onAppear
        case confirmCodeTapped
        case digitAdded(String)
        case digitRemoved
        case setActiveIndex(Int)
        case updateCode(String)
    }
    
    // MARK: - Public methods
    
    public func send(event: Event) {
        Task { @MainActor in
            switch event {
            case .onAppear:
                await handleOnAppear()
            case .confirmCodeTapped:
                await performConfirmation()
            case .digitAdded(let digit):
                addDigit(digit)
            case .digitRemoved:
                removeDigit()
            case .setActiveIndex(let index):
                setActiveIndex(index)
            case .updateCode(let code):
                updateConfirmationCode(code)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func handleOnAppear() async {
        confirmationCode = ""
        activeIndex = 0
        codeError = nil
        errorMessage = nil
        isLoading = false
    }
    
    private func digit(at index: Int) -> String {
        guard index < confirmationCode.count else { return "" }
        let stringIndex = confirmationCode.index(confirmationCode.startIndex, offsetBy: index)
        return String(confirmationCode[stringIndex])
    }
    
    private func setActiveIndex(_ index: Int) {
        activeIndex = index
    }
    
    private func addDigit(_ digit: String) {
        guard digit.count == 1, confirmationCode.count < 6 else { return }
        
        let newCode = confirmationCode + digit
        confirmationCode = String(newCode.prefix(6))
        
        if confirmationCode.count < 6 {
            activeIndex = confirmationCode.count
        } else {
            activeIndex = 5
        }
        
        codeError = nil
        errorMessage = nil
    }
    
    private func removeDigit() {
        guard !confirmationCode.isEmpty else { return }
        
        confirmationCode.removeLast()
        activeIndex = max(0, confirmationCode.count)
        
        codeError = nil
        errorMessage = nil
    }
    
    private func performConfirmation() async {
        isLoading = true
        errorMessage = nil
        codeError = nil
        
        guard confirmationCode.count == 6 else {
            codeError = "Confirmation code must be 6 digits"
            isLoading = false
            return
        }
        
        // TODO: Implement actual API call for code confirmation
        do {
            try await Task.sleep(nanoseconds: 1_500_000_000)
            if confirmationCode == "123456" {
                didConfirm = true
            } else {
                codeError = "Invalid confirmation code"
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func updateConfirmationCode(_ code: String) {
        confirmationCode = String(code.prefix(6))
        activeIndex = min(confirmationCode.count, 5)
        codeError = nil
        errorMessage = nil
    }
}
