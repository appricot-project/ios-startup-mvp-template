//
//  OTPDigitView.swift
//  PitchDeckUIKit
//
//  Created by Anton Redkozubov on 30.01.2026.
//

import SwiftUI

public struct OTPDigitView: View {
    @Binding var digit: String
    let isActive: Bool
    let isFocused: Bool
    
    public init(digit: Binding<String>, isActive: Bool, isFocused: Bool) {
        self._digit = digit
        self.isActive = isActive
        self.isFocused = isFocused
    }
    
    public var body: some View {
        TextField("", text: $digit)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .frame(width: 50, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isActive ? Color.blue : Color.gray.opacity(0.3), lineWidth: isActive ? 2 : 1)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.globalBackgroundColor))
                    )
            )
            .cornerRadius(12)
            .scaleEffect(isActive ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isActive)
            .onChange(of: digit) { newValue in
                let filtered = String(newValue.prefix(1))
                if filtered.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil {
                    if digit != filtered {
                        digit = filtered
                    }
                } else {
                    digit = ""
                }
            }
    }
}
