//
//  AuthStartScreen.swift
//  PitchDeckAuthKit
//
//  Created by Anton Redkozubov on 21.01.2026.
//

import SwiftUI
import PitchDeckUIKit

public struct AuthMainScreen: View {
    
    let onSelectConfirmation: (String) -> Void
    let onAuthorizationCompleted: (() -> Void)?
    @ObservedObject private var viewModel: AuthMainViewModel
    @State private var presenter: UIViewController?
    
    
    public init(
        viewModel: AuthMainViewModel,
        onSelectConfirmation: @escaping (String) -> Void,
        onAuthorizationCompleted: (() -> Void)? = nil
    ) {
        self.viewModel = viewModel
        self.onSelectConfirmation = onSelectConfirmation
        self.onAuthorizationCompleted = onAuthorizationCompleted
    }
    
    public var body: some View {
        ZStack {
            Color(UIColor.globalBackgroundColor)
                .ignoresSafeArea()
            
            VStack {
                Text("auth.signIn.title".localized)
                    .font(.title)
                    .padding(.top, 24)
                Spacer()
            }
            
            VStack(spacing: 0) {
                BasicTextField(
                    title: "auth.signIn.email.textField".localized,
                    fieldName: "",
                    fieldValue: $viewModel.email,
                    isSecure: false
                )
                .onChange(of: viewModel.email) { newValue in
                    viewModel.send(event: .emailChanged(newValue))
                }
                
                if let emailError = viewModel.emailError {
                    Text(emailError)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 4)
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.top, 16)
                }
                
                Spacer()
                
                PrimaryButton("auth.signIn.button.title".localized) {
                    guard let presenter else { return }
                    viewModel.send(event: .loginTapped(presenter: presenter))
                }
                .disabled(!viewModel.isLoginEnabled)
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 16)
            .padding(.top, 80)
            
            if viewModel.isLoading {
                Color(UIColor.globalBackgroundColor)
                    .ignoresSafeArea()
                    .overlay {
                        LoadingView()
                    }
            }
        }
        .background(
            ViewControllerResolver { viewController in
                presenter = viewController
            }
        )
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            viewModel.send(event: .onAppear)
        }
        .onChange(of: viewModel.didAuthorize) { didAuthorize in
            guard didAuthorize else { return }
            onAuthorizationCompleted?()
        }
    }
}
