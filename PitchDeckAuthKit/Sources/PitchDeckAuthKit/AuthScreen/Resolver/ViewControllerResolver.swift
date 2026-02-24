//
//  ViewControllerResolver.swift
//  PitchDeckAuthKit
//
//  Created by Anton Redkozubov on 15.01.2026.
//

import UIKit
import SwiftUI

public struct ViewControllerResolver: UIViewControllerRepresentable {
    
    let onResolve: (UIViewController) -> Void
    
    public func makeUIViewController(context: Context) -> ResolverViewController {
        ResolverViewController(onResolve: onResolve)
    }
    
    public func updateUIViewController(_ uiViewController: ResolverViewController, context: Context) {
        uiViewController.onResolve = onResolve
    }
    
    final public class ResolverViewController: UIViewController {
        
        var onResolve: (UIViewController) -> Void
        
        init(onResolve: @escaping (UIViewController) -> Void) {
            self.onResolve = onResolve
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            return nil
        }
        
        public override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            guard let parent else { return }
            onResolve(parent)
        }
    }
}
