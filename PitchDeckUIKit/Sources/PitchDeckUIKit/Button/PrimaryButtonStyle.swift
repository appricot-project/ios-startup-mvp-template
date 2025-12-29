//
//  PrimaryButtonStyle.swift
//  PitchDeckUIKit
//
//  Created by Anatoly Nevmerzhitsky on 11.12.2025.
//

import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44)
            .foregroundColor(.white)
            .background(configuration.isPressed ? Color.purple.opacity(0.7) : Color.purple)
            .cornerRadius(12)
//            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
