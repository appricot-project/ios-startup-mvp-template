//
//  UpdateStartupRequest.swift
//  PitchDeckMainApiKit
//
//  Created by Cascade on 10.02.2026.
//

import Foundation

public struct UpdateStartupRequest: Sendable {
    public let documentId: String
    public let title: String
    public let description: String
    public let location: String
    public let categoryId: String
    public let imageData: Data?
    
    public init(
        documentId: String,
        title: String,
        description: String,
        location: String,
        categoryId: String,
        imageData: Data? = nil
    ) {
        self.documentId = documentId
        self.title = title
        self.description = description
        self.location = location
        self.categoryId = categoryId
        self.imageData = imageData
    }
}
