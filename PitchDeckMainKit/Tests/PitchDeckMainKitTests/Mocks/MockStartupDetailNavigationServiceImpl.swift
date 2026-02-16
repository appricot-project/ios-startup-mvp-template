//
//  MockStartupDetailNavigationServiceImpl.swift
//  PitchDeckMainKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import Foundation
import SwiftUI
@testable import PitchDeckMainApiKit

final class MockStartupDetailNavigationServiceImpl: StartupDetailNavigationService {
    
    var buildViewCallCount = 0
    var lastDocumentId: String?
    var lastCurrentUserEmail: String?
    var lastOnEditTapped: ((String) -> Void)?
    var lastOnDeleteSuccess: (() -> Void)?
    
    func buildStartupDetailView(
        documentId: String,
        currentUserEmail: String,
        onEditTapped: ((String) -> Void)?,
        onDeleteSuccess: (() -> Void)?
    ) -> AnyView {
        buildViewCallCount += 1
        lastDocumentId = documentId
        lastCurrentUserEmail = currentUserEmail
        lastOnEditTapped = onEditTapped
        lastOnDeleteSuccess = onDeleteSuccess
        
        return AnyView(Text("Mock Startup Detail View"))
    }
    
    func reset() {
        buildViewCallCount = 0
        lastDocumentId = nil
        lastCurrentUserEmail = nil
        lastOnEditTapped = nil
        lastOnDeleteSuccess = nil
    }
}
