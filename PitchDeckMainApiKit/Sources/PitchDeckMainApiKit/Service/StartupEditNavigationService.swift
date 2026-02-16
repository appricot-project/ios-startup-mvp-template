//
//  StartupEditNavigationService.swift
//  PitchDeckMainApiKit
//
//  Created by Cascade on 10.02.2026.
//

import Foundation
import SwiftUI

public protocol StartupEditNavigationService {
    func buildStartupEditView(documentId: String, onStartupUpdated: @escaping () -> Void) -> AnyView
}
