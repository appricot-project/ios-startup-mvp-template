//
//  AuthMainScreen.swift
//  PitchDeckAuthKit
//
//  Created by Anatoly Nevmerzhitsky on 10.12.2025.
//

import SwiftUI
import PitchDeckUIKit

public struct AuthMainScreen: View {
    
    let onSelectConfirmation: (String) -> Void
    @ObservedObject private var viewModel: AuthMainViewModel
    @State private var presenter: UIViewController?
    
    
    public init(
        viewModel: AuthMainViewModel,
        onSelectConfirmation: @escaping (String) -> Void
    ) {
        self.viewModel = viewModel
        self.onSelectConfirmation = onSelectConfirmation
    }
    
    public var body: some View {
        ZStack {
            Color(UIColor.globalBackgroundColor)
                .ignoresSafeArea()
            VStack {
                Text("Auth sceen")
                    .font(.title)
                    .padding(.top, 24)
                Spacer()
            }

            VStack(spacing: 0) {
                BasicTextField(
                    title: "Email",
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
                        .padding(.top, 4)
                }

                PrimaryButton("Auth") {
                    guard let presenter else { return }
                    viewModel.send(event: .loginTapped(presenter: presenter))
                }
                .disabled(!viewModel.isLoginEnabled)
                .padding(.top, 40)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.top, 16)
                }
            }
            .padding(.horizontal, 16)

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
        .onChange(of: viewModel.didAuthorize) { didAuthorize in
            guard didAuthorize else { return }
            onSelectConfirmation(viewModel.email)
        }
    }
}
