//
//  UIApplication.swift
//  PitchDeckUIKit
//
//  Created by Anatoly Nevmerzhitsky on 11.12.2025.
//

import SwiftUI

public extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}
