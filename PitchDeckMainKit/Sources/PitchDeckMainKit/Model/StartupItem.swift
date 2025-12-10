//
//  StartupItem.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 09.12.2025.
//

import Foundation

struct StartupItem: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String?
    let image: String?
    let category: String
    let location: String
}
