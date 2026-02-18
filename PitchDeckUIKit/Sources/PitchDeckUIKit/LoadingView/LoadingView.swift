//
//  LoadingView.swift
//  PitchDeckUIKit
//
//  Created by Anton Redkozubov on 18.12.2025.
//

import SwiftUI
import Lottie

public struct LoadingView: View {
    
    // MARK: - Properties
    
    private let size: LoadingSize
    
    // MARK: - Init
    
    public init(size: LoadingSize = .large) {
        self.size = size
    }
    
    // MARK: - View
    
    public var body: some View {
        ZStack {
            if size == .large {
                Color(UIColor.globalBackgroundColor)
                    .ignoresSafeArea()
            }
            
            LottieView(animation: .named("loader"))
                .configure(\.contentMode, to: .scaleAspectFit)
                .looping()
                .playing()
                .frame(width: size.width, height: size.height)
        }
        .navigationBarHidden(size == .large)
        .ignoresSafeArea(edges: size == .large ? .all : [])
    }
}

// MARK: - LoadingSize

public extension LoadingView {
    enum LoadingSize {
        case small
        case large
        
        var width: CGFloat {
            switch self {
            case .small: return 80
            case .large: return 240
            }
        }
        
        var height: CGFloat {
            switch self {
            case .small: return 80
            case .large: return 240
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        LoadingView(size: .small)
        LoadingView(size: .large)
    }
}
