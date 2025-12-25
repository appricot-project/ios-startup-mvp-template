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
    func getStartups(title: String?, categoryId: Int?, page: Int, pageSize: Int) async throws -> [StartupItem]
    func getStartupsCategoris() async throws -> [CategoryItem]
}
