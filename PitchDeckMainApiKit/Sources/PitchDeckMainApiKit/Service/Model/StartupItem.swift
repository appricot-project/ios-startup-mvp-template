//
//  StartupItem.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 09.12.2025.
//

import Foundation

public struct StartupItem: Equatable, Sendable, Identifiable {
    public let id: Int
    public let documentId: String
    public let title: String
    public let description: String?
    public let image: String?
    public let category: String
    public let location: String
    public let ownerEmail: String
    
    public init(id: Int, documentId: String, title: String, description: String?, image: String?, category: String, location: String, ownerEmail: String) {
        self.id = id
        self.documentId = documentId
        self.title = title
        self.description = description
        self.image = image
        self.category = category
        self.location = location
        self.ownerEmail = ownerEmail
    }
}
