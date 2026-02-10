//
//  StartupDetailNavigationService.swift
//  PitchDeckMainApiKit
//
//  Created by Cascade on 10.02.2026.
//

import Foundation
import SwiftUI

public protocol StartupDetailNavigationService {
    func buildStartupDetailView(documentId: String, currentUserEmail: String, onEditTapped: ((String) -> Void)?) -> AnyView
}
