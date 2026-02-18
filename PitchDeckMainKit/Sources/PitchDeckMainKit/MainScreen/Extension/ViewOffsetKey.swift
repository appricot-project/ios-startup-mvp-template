//
//  ViewOffsetKey.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 18.02.2026.
//

import Foundation
import SwiftUI

struct ViewOffsetKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
