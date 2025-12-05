//
//  CabinetScreen.swift
//  PitchDeckCabinetKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import Foundation
import SwiftUI

public struct CabinetScreen: View {

    let onSettingsTap: () -> Void
    
    public init(onSettingsTap: @escaping () -> Void) {
        self.onSettingsTap = onSettingsTap
    }
    
    public var body: some View {
        VStack {
            Text("Cabinet Screen")
            Button("Settings") {
                onSettingsTap()
            }
        }
    }
}
