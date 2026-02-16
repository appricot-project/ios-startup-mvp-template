//
//  MockStartupEditNavigationService.swift
//  PitchDeckCabinetKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import Foundation
import SwiftUI
@testable import PitchDeckMainApiKit

final class MockStartupEditNavigationService: StartupEditNavigationService {
    
    var buildViewCallCount = 0
    var lastDocumentId: String?
    var lastOnStartupUpdated: (() -> Void)?
    
    func buildStartupEditView(
        documentId: String,
        onStartupUpdated: @escaping () -> Void
    ) -> AnyView {
        buildViewCallCount += 1
        lastDocumentId = documentId
        lastOnStartupUpdated = onStartupUpdated
        
        return AnyView(Text("Mock Startup Edit View"))
    }
    
    func reset() {
        buildViewCallCount = 0
        lastDocumentId = nil
        lastOnStartupUpdated = nil
    }
}
