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
    @State private var digits: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    
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
            VStack(spacing: 0) {
                VStack(spacing: 8) {
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
                .padding(.horizontal, 16)
                
                Spacer()
                
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        ForEach(0..<6, id: \.self) { index in
                            OTPDigitView(
                                digit: $digits[index],
                                isActive: viewModel.activeIndex == index,
                                isFocused: focusedField == index
                            )
                            .focused($focusedField, equals: index)
                            .onChange(of: digits[index]) { newValue in
                                handleDigitChange(at: index, value: newValue)
                            }
                            .onTapGesture {
                                viewModel.setActiveIndex(index)
                                focusedField = index
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
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
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
        }
        .onChange(of: viewModel.didConfirm) { didConfirm in
            guard didConfirm else { return }
            onConfirmationSuccess()
        }
    }
    
    private func handleDigitChange(at index: Int, value: String) {
        guard !value.isEmpty else { return }
        
        var newCode = viewModel.confirmationCode
        if newCode.count > index {
            newCode = String(newCode.prefix(index)) + value + String(newCode.suffix(newCode.count - index - 1))
        } else {
            newCode += value
        }
        viewModel.confirmationCode = String(newCode.prefix(6))
        if index < 5 && !value.isEmpty {
            viewModel.setActiveIndex(index + 1)
            focusedField = index + 1
        }
    }
}
