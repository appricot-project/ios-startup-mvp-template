//
//  CategoryItem.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 09.12.2025.
//

import Foundation

public struct CategoryItem: Identifiable, Equatable, Sendable {
    public let id: Int
    public let documentId: String
    public let title: String
    
    public init(id: Int, documentId: String, title: String) {
        self.id = id
        self.documentId = documentId
        self.title = title
    }
}
