//
//  AuthStartScreen.swift
//  PitchDeckAuthKit
//
//  Created by Anton Redkozubov on 21.01.2026.
//

import SwiftUI
import PitchDeckUIKit

public struct AuthStartScreen: View {
    
    public let onLogin: () -> Void
    public let onRegistration: () -> Void
    
    public init(
        onLogin: @escaping () -> Void,
        onRegistration: @escaping () -> Void
    ) {
        self.onLogin = onLogin
        self.onRegistration = onRegistration
    }
    
    public var body: some View {
        ZStack {
            Color(UIColor.globalBackgroundColor)
                .ignoresSafeArea()
            
            VStack {
                VStack(spacing: 16) {
                    Text("auth.start.title".localized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("auth.start.subtitle".localized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                Spacer()
            }
            
            VStack(spacing: 16) {
                Spacer()
                
                PrimaryButton("auth.start.button.title.login".localized) {
                    onLogin()
                }
                
                SecondaryButton(title: "auth.start.button.title.sign".localized) {
                    onRegistration()
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 16)
            .padding(.top, 80)
        }
    }
}
