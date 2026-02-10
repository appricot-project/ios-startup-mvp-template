//
//  StartupService.swift
//  PitchDeckMainApiKit
//
//  Created by Anton Redkozubov on 22.12.2025.
//

import Foundation

@MainActor
public protocol StartupService: Sendable {
    func getStartup(documentId: String) async throws -> StartupItem
    func getStartups(title: String?, categoryId: Int?, email: String?, page: Int, pageSize: Int) async throws -> StartupPageResult
    func getStartupsCategories() async throws -> [CategoryItem]
    func createStartup(request: CreateStartupRequest) async throws -> StartupItem
    func updateStartup(request: UpdateStartupRequest) async throws -> StartupItem
    func deleteStartup(documentId: String) async throws -> Bool
}
