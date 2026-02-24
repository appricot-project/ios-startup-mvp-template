//
//  ShareSheet.swift
//  PitchDeckUIKit
//
//  Created by Anton Redkozubov on 13.01.2026.
//

import Foundation
import SwiftUI

public struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    public init(activityItems: [Any]) {
        self.activityItems = activityItems
    }
    
    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
