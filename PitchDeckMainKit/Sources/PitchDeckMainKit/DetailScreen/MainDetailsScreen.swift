//
//  MainDetailsScreen.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import Foundation
import SwiftUI

struct MainDetailsScreen: View {
    let id: Int

    var body: some View {
        VStack {
            Text("Main Details Screen, id = \(id)")
                .font(.title)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
