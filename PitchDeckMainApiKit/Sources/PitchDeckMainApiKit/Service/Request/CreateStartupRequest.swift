//
//  CreateStartupRequest.swift
//  PitchDeckMainApiKit
//
//  Created by Anton Redkozubov on 03.02.2026.
//

import Foundation

public struct CreateStartupRequest: Sendable {
    public let ownerEmail: String
    public let title: String
    public let description: String
    public let location: String
    public let categoryId: Int
    public let imageData: Data?
    
    public init(ownerEmail: String, title: String, description: String, location: String, categoryId: Int, imageData: Data?) {
        self.ownerEmail = ownerEmail
        self.title = title
        self.description = description
        self.location = location
        self.categoryId = categoryId
        self.imageData = imageData
    }
}
