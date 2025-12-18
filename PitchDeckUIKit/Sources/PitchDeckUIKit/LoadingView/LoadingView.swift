//
//  LoadingView.swift
//  PitchDeckUIKit
//
//  Created by Anton Redkozubov on 18.12.2025.
//

import SwiftUI
import Lottie

public struct LoadingView: View {
    
    // MARK: - Public properties
    
    var alphaComponent: CGFloat = 0.8
    @State var show: Bool
    
    // MARK: - View
    
    public init(show: Bool) {
        self.show = show
    }
    
    public var body: some View {
        if show {
            ZStack {
                Color(UIColor.globalBackgroundColor)
                    .opacity(alphaComponent)
                    .ignoresSafeArea()
                LottieView(animation: .named("loader"))
                    .configure(\.contentMode, to: .scaleAspectFit)
                    .looping()
                    .playing()
                    .frame(width: 100, height: 100)
            }
            .navigationBarHidden(true)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    LoadingView(show: true)
}
