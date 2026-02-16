//
//  SnapshotHelpers.swift
//  PitchDeckAuthKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import SwiftUI
import UIKit

extension SwiftUI.View {
    func snapshotController() -> UIViewController {
        let hostingController = UIHostingController(rootView: self)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 812) // iPhone 11 dimensions
        hostingController.view.backgroundColor = UIColor.white
        return hostingController
    }
}
