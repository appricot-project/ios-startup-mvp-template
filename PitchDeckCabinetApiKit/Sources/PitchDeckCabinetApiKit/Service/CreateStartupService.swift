//
//  CreateStartupService.swift
//  PitchDeckCabinetApiKit
//
//  Created by Anton Redkozubov on 03.02.2026.
//

import Foundation
import PitchDeckMainApiKit

public protocol CreateStartupService: Sendable {
    func getStartupsCategories() async throws -> [CategoryItem]
    func createStartup(request: CreateStartupRequest) async throws -> StartupItem
}
