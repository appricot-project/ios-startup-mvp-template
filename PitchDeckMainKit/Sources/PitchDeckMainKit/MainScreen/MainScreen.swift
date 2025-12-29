//
//  MainScreen.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import SwiftUI

public struct MainScreen: View {
    
    let onSelectDetail: (Int) -> Void
    
    public init(onSelectDetail: @escaping (Int) -> Void) {
        self.onSelectDetail = onSelectDetail
    }
    
    public var body: some View {
        VStack {
            Text("Main Screen")
            Button("Open Details") {
                onSelectDetail(42)
            }
        }
    }
}
