//
//  PrimaryButton.swift
//  PitchDeckUIKit
//
//  Created by Anton Redkozubov on 18.12.2025.
//

import Foundation
import SwiftUI

public struct PrimaryButton: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(cgColor: CGColor(red: 191 / 255.0, green: 234 / 255.0, blue: 129 / 255.0, alpha: 1.0)))
            .foregroundStyle(.black)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
