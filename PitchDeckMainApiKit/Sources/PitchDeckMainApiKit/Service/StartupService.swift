//
//  StartupService.swift
//  PitchDeckMainApiKit
//
//  Created by Anton Redkozubov on 22.12.2025.
//

import Foundation

@MainActor
public protocol StartupService: Sendable {
    func startups(page: Int, pageSize: Int) async throws -> [StartupItem]
    func serchStartup(filter: String, page: Int, pageSize: Int) async throws -> [StartupItem]
    func startupsCategoris() async throws -> [CategoryItem]
}
