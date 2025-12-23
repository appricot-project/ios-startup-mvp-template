//
//  View.swift
//  PitchDeckUIKit
//
//  Created by Anton Redkozubov on 22.12.2025.
//

import SwiftUI

public extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
    
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                           to: nil,
                                           from: nil,
                                           for: nil)
        }
    }
    
    func hideKeyboardOnTapBackground() -> some View {
        self.background(
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                   to: nil,
                                                   from: nil,
                                                   for: nil)
                }
        )
    }
}
