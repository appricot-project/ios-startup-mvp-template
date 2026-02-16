//
//  SecondaryButton.swift
//  PitchDeckUIKit
//
//  Created by Anton Redkozubov on 21.01.2026.
//

import SwiftUI

public struct SecondaryButton: View {
    private let title: String
    private let action: () -> Void
    
    @State private var isPressed = false
    
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(UIColor.blueD1))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(UIColor.blueD1), lineWidth: 1)
                        .fill(Color.clear)
                )
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
