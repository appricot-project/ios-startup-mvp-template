//
//  LoadingView.swift
//  PitchDeckUIKit
//
//  Created by Anton Redkozubov on 18.12.2025.
//

import SwiftUI
import Lottie

public struct LoadingView: View {
    
    // MARK: - View
    
    public init() { }
    
    public var body: some View {
        ZStack {
            Color(UIColor.globalBackgroundColor)
                .ignoresSafeArea()
            LottieView(animation: .named("loader"))
                .configure(\.contentMode, to: .scaleAspectFit)
                .looping()
                .playing()
                .frame(width: 240, height: 240)
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

#Preview {
    LoadingView()
}
