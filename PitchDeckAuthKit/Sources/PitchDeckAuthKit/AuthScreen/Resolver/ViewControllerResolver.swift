//
//  ViewControllerResolver.swift
//  PitchDeckAuthKit
//
//  Created by Anton Redkozubov on 15.01.2026.
//

import UIKit
import SwiftUI

private struct ViewControllerResolver: UIViewControllerRepresentable {
    
    let onResolve: (UIViewController) -> Void
    
    func makeUIViewController(context: Context) -> ResolverViewController {
        ResolverViewController(onResolve: onResolve)
    }
    
    func updateUIViewController(_ uiViewController: ResolverViewController, context: Context) {
        uiViewController.onResolve = onResolve
    }
    
    final class ResolverViewController: UIViewController {
        
        var onResolve: (UIViewController) -> Void
        
        init(onResolve: @escaping (UIViewController) -> Void) {
            self.onResolve = onResolve
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            return nil
        }
        
        override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            guard let parent else { return }
            onResolve(parent)
        }
    }
}
