import Foundation
import UIKit
import PitchDeckAuthApiKit

@MainActor
public final class AuthMainViewModel: ObservableObject {

    // MARK: - Published properties

    @Published public var email: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    @Published public var didAuthorize: Bool = false
    @Published public var emailError: String? = nil

    public var isLoginEnabled: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Private properties

    private let authService: AuthService

    // MARK: - Init

    public init(authService: AuthService) {
        self.authService = authService
    }

    // MARK: - Event

    public enum Event {
        case onAppear
        case loginTapped(presenter: UIViewController)
        case logoutTapped
        case emailChanged(String)
    }

    // MARK: - Public methods
    
    public func send(event: Event) {
        Task { @MainActor in
            switch event {
            case .onAppear:
                await handleOnAppear()
            case .loginTapped(let presenter):
                await login(presenter: presenter)
            case .logoutTapped:
                await authService.logout()
                didAuthorize = false
            case .emailChanged(let email):
                self.email = email
                validateEmail()
            }
        }
    }

    // MARK: - Private methods

    private func handleOnAppear() async {
        errorMessage = nil
        emailError = nil
        isLoading = false
    }
    
    private func validateEmail() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedEmail.isEmpty {
            emailError = nil
        } else if !isValidEmail(trimmedEmail) {
            emailError = "Wrong email format"
        } else {
            emailError = nil
        }
    }

    private func login(presenter: UIViewController) async {
        errorMessage = nil
        emailError = nil

        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            emailError = "Email cannot be empty"
            return
        }

        guard isValidEmail(email.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            emailError = "Wrong email format"
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let (tokens, profile) = try await authService.authorize(
                loginHint: email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : email,
                presentationContext: presenter
            )
            print("[AuthMainViewModel] login success: profile=\(profile)")
            didAuthorize = true
        } catch {
            errorMessage = error.localizedDescription
            didAuthorize = false
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
