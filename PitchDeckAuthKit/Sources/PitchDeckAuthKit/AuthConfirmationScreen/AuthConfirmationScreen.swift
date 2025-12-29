//
//  AuthConfirmationScreen.swift
//  PitchDeckAuthKit
//
//  Created by Anatoly Nevmerzhitsky on 11.12.2025.
//

import Foundation

import SwiftUI

struct AuthConfirmationScreen: View {
    let email: String

    var body: some View {
        VStack {
            Text("Confirmation \(email)")
                .font(.title)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
