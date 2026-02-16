//
//  SnapshotHelpers.swift
//  PitchDeckCabinetKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import SwiftUI
import SnapshotTesting

extension SwiftUI.View {
    func snapshotController() -> UIViewController {
        let hosting = UIHostingController(rootView: self)

        hosting.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
        hosting.view.setNeedsLayout()
        hosting.view.layoutIfNeeded()
        hosting.view.backgroundColor = .systemBackground

        return hosting
    }
}
