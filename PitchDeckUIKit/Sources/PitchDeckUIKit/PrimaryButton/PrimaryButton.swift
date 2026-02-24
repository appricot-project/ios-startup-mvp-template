//
//  PrimaryButton.swift
//  PitchDeckUIKit
//
//  Created by Anton Redkozubov on 18.12.2025.
//

import SwiftUI

public struct PrimaryButton: View {
    private let title: String
    private let action: () -> Void
    
    @State private var isPressed = false
    
    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(UIColor.globalSubtitleColor))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.blueD1))
                )
                .foregroundStyle(.black)
                .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(.plain)
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.2)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.15)) {
                    isPressed = false
                }
            }
        }
    }
}
