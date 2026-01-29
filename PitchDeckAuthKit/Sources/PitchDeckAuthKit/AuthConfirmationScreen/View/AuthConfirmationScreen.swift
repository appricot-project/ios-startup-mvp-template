//
//  AuthConfirmationScreen.swift
//  PitchDeckAuthKit
//
//  Created by Anton Redkozubov on 21.01.2026.
//

import SwiftUI
import PitchDeckUIKit

public struct AuthConfirmationScreen: View {
    
    @ObservedObject private var viewModel: AuthConfirmationViewModel
    public let onConfirmationSuccess: () -> Void
    
    public init(
        email: String,
        onConfirmationSuccess: @escaping () -> Void
    ) {
        self.viewModel = AuthConfirmationViewModel(email: email)
        self.onConfirmationSuccess = onConfirmationSuccess
    }
    
    public var body: some View {
        ZStack {
            Color(UIColor.globalBackgroundColor)
                .ignoresSafeArea()
            
            VStack {
                VStack(spacing: 16) {
                    Text("auth.confirm.title".localized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("auth.confirm.subtitle".localized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(viewModel.email)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .padding(.top, 24)
                Spacer()
            }
            
            VStack(spacing: 0) {
                BasicTextField(
                    title: "auth.confirm.code.textField".localized,
                    fieldName: "",
                    fieldValue: $viewModel.confirmationCode,
                    isSecure: false
                )
                .onChange(of: viewModel.confirmationCode) { _ in
                    viewModel.updateConfirmationCode(viewModel.confirmationCode)
                }
                
                if let codeError = viewModel.codeError {
                    Text(codeError)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 4)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 16)
                }
                
                Text("auth.confirm.code.text".localized)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
                
                Spacer()
                
                PrimaryButton("auth.confirm.button.title".localized) {
                    viewModel.confirmCode()
                }
                .disabled(!viewModel.isConfirmationEnabled)
                .padding(.horizontal, 16)
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
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onChange(of: viewModel.didConfirm) { didConfirm in
            guard didConfirm else { return }
            onConfirmationSuccess()
        }
    }
}
