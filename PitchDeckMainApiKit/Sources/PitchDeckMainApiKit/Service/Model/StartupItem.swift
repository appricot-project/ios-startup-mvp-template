//
//  StartupItem.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 09.12.2025.
//

import Foundation

public struct StartupItem: Equatable, Sendable, Identifiable {
    public let id: Int
    public let title: String
    public let description: String?
    public let image: String?
    public let category: String
    public let location: String
    
    public init(id: Int, title: String, description: String?, image: String?, category: String, location: String) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.category = category
        self.location = location
    }
}
