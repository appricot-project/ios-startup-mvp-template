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
    @State private var email = ""

    
    public init(onSelectConfirmation: @escaping (String) -> Void) {
        self.onSelectConfirmation = onSelectConfirmation
    }
        
    public var body: some View {
        VStack {
            Text("Auth sceen")
                .font(.title)
                .padding()
            Spacer()
            BasicTextField(title: "Email", fieldName: "", fieldValue: $email, isSecure: false)
            Button("Auth") {
                onSelectConfirmation("mail@test.com")
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.vertical, 24)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .padding(.horizontal, 16)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}
