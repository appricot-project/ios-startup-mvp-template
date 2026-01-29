//
//  AuthRegistrationScreen.swift
//  PitchDeckAuthKit
//
//  Created by Anton Redkozubov on 21.01.2026.
//

import SwiftUI
import PitchDeckUIKit

public struct AuthRegistrationScreen: View {
    
    @ObservedObject private var viewModel: AuthRegistrationViewModel
    public let onRegistered: (String) -> Void
    
    public init(
        viewModel: AuthRegistrationViewModel = AuthRegistrationViewModel(),
        onRegistered: @escaping (String) -> Void
    ) {
        self.viewModel = viewModel
        self.onRegistered = onRegistered
    }
    
    public var body: some View {
        ZStack {
            Color(UIColor.globalBackgroundColor)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                VStack(spacing: 16) {
                    Text("auth.signUp.title".localized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("auth.signUp.subtitle".localized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 20) {
                    BasicTextField(
                        title: "auth.signUp.email.textField".localized,
                        fieldName: "",
                        fieldValue: $viewModel.email,
                        isSecure: false
                    )
                    .onChange(of: viewModel.email) { _ in
                        viewModel.emailError = nil
                    }
                    
                    if let emailError = viewModel.emailError {
                        Text(emailError)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, -16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    BasicTextField(
                        title: "auth.signUp.email.firstName".localized,
                        fieldName: "",
                        fieldValue: $viewModel.firstName,
                        isSecure: false
                    )
                    .onChange(of: viewModel.firstName) { _ in
                        viewModel.firstNameError = nil
                    }
                    
                    if let firstNameError = viewModel.firstNameError {
                        Text(firstNameError)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, -16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    BasicTextField(
                        title: "auth.signUp.email.lastName".localized,
                        fieldName: "",
                        fieldValue: $viewModel.lastName,
                        isSecure: false
                    )
                    .onChange(of: viewModel.lastName) { _ in
                        viewModel.lastNameError = nil
                    }
                    
                    if let lastNameError = viewModel.lastNameError {
                        Text(lastNameError)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, -16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    PrimaryButton("auth.signUp.button.title".localized) {
                        viewModel.register()
                    }
                    .disabled(!viewModel.isRegistrationEnabled)
                    .padding(.top, 20)
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            
            if viewModel.isLoading {
                Color(UIColor.globalBackgroundColor)
                    .ignoresSafeArea()
                    .overlay {
                        LoadingView()
                    }
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onChange(of: viewModel.didRegister) { didRegister in
            guard didRegister else { return }
            onRegistered(viewModel.email)
        }
    }
}
