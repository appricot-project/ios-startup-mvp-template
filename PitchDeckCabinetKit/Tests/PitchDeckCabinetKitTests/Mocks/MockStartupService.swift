//
//  MockStartupService.swift
//  PitchDeckCabinetKitTests
//
//  Created by Anton Redkozubov on 16.02.2026.
//

import Foundation
@testable import PitchDeckMainApiKit

@MainActor
final class MockStartupService: StartupService {
    
    // MARK: - Mock data
    
    var mockStartups: [StartupItem] = []
    var mockCategories: [CategoryItem] = []
    var mockStartupDetail: StartupItem?
    var mockPageInfo: PageInfo?
    
    // MARK: - Error simulation
    
    var shouldFailGetStartup = false
    var shouldFailGetStartups = false
    var shouldFailGetCategories = false
    var shouldFailCreateStartup = false
    var shouldFailUpdateStartup = false
    var shouldFailDeleteStartup = false
    var errorToThrow: Error = NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
    
    // MARK: - Call tracking
    
    var getStartupCallCount = 0
    var getStartupsCallCount = 0
    var getStartupsCategoriesCallCount = 0
    var createStartupCallCount = 0
    var updateStartupCallCount = 0
    var deleteStartupCallCount = 0
    
    var lastGetStartupDocumentId: String?
    var lastGetStartupsTitle: String?
    var lastGetStartupsCategoryId: Int?
    var lastGetStartupsEmail: String?
    var lastGetStartupsPage: Int?
    var lastGetStartupsPageSize: Int?
    var lastCreateStartupRequest: CreateStartupRequest?
    var lastUpdateStartupRequest: UpdateStartupRequest?
    var lastDeleteStartupDocumentId: String?
    
    // MARK: - Methods
    
    func getStartup(documentId: String) async throws -> StartupItem {
        getStartupCallCount += 1
        lastGetStartupDocumentId = documentId
        
        if shouldFailGetStartup {
            throw errorToThrow
        }
        
        if let mockStartupDetail = mockStartupDetail {
            return mockStartupDetail
        }
        
        throw NSError(domain: "MockError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Startup not found"])
    }
    
    func getStartups(title: String?, categoryId: Int?, email: String?, page: Int, pageSize: Int) async throws -> StartupPageResult {
        getStartupsCallCount += 1
        lastGetStartupsTitle = title
        lastGetStartupsCategoryId = categoryId
        lastGetStartupsEmail = email
        lastGetStartupsPage = page
        lastGetStartupsPageSize = pageSize
        
        if shouldFailGetStartups {
            throw errorToThrow
        }
        
        let startIndex = (page - 1) * pageSize
        let endIndex = min(startIndex + pageSize, mockStartups.count)
        let pageItems = Array(mockStartups[startIndex..<endIndex])
        
        return StartupPageResult(
            items: pageItems,
            pageInfo: mockPageInfo
        )
    }
    
    func getStartupsCategories() async throws -> [CategoryItem] {
        getStartupsCategoriesCallCount += 1
        
        if shouldFailGetCategories {
            throw errorToThrow
        }
        
        return mockCategories
    }
    
    func createStartup(request: CreateStartupRequest) async throws -> StartupItem {
        createStartupCallCount += 1
        lastCreateStartupRequest = request
        
        if shouldFailCreateStartup {
            throw errorToThrow
        }
        
        return StartupItem(
            id: Int.random(in: 1...1000),
            documentId: "new-startup-\(Int.random(in: 1...1000))",
            title: request.title,
            description: request.description,
            image: request.imageData != nil ? "image.jpg" : nil,
            category: "Tech",
            location: request.location,
            ownerEmail: "test@test.com"
        )
    }
    
    func deleteStartup(documentId: String) async throws {
        deleteStartupCallCount += 1
        lastDeleteStartupDocumentId = documentId
        
        if shouldFailDeleteStartup {
            throw errorToThrow
        }
    }
    
    // MARK: - Helper methods
    
    func reset() {
        mockStartups = []
        mockCategories = []
        mockStartupDetail = nil
        mockPageInfo = nil
        
        shouldFailGetStartup = false
        shouldFailGetStartups = false
        shouldFailGetCategories = false
        shouldFailCreateStartup = false
        shouldFailUpdateStartup = false
        shouldFailDeleteStartup = false
        
        getStartupCallCount = 0
        getStartupsCallCount = 0
        getStartupsCategoriesCallCount = 0
        createStartupCallCount = 0
        updateStartupCallCount = 0
        deleteStartupCallCount = 0
        
        lastGetStartupDocumentId = nil
        lastGetStartupsTitle = nil
        lastGetStartupsCategoryId = nil
        lastGetStartupsEmail = nil
        lastGetStartupsPage = nil
        lastGetStartupsPageSize = nil
        lastCreateStartupRequest = nil
        lastUpdateStartupRequest = nil
        lastDeleteStartupDocumentId = nil
    }
    
    // MARK: - Data factory
    
    static func createMockStartupItems(count: Int) -> [StartupItem] {
        return (0..<count).map { index in
            StartupItem(
                id: index + 1,
                documentId: "doc-\(index + 1)",
                title: "Startup \(index + 1)",
                description: "Description for startup \(index + 1)",
                image: "image-\(index + 1).jpg",
                category: "Tech",
                location: "City \(index + 1)",
                ownerEmail: "test@test.com"
            )
        }
    }
    
    static func createMockCategoryItems(count: Int) -> [CategoryItem] {
        return (0..<count).map { index in
            CategoryItem(
                id: index + 1,
                documentId: "1",
                title: "Category \(index + 1)"
            )
        }
    }
    
    static func createMockPageInfo(page: Int, pageSize: Int, total: Int) -> PageInfo {
        let pageCount = (total + pageSize - 1) / pageSize
        return PageInfo(
            page: page,
            pageSize: pageSize,
            pageCount: pageCount,
            total: total
        )
    }
    
    func updateStartup(request: UpdateStartupRequest) async throws -> StartupItem {
        updateStartupCallCount += 1
        lastUpdateStartupRequest = request
        
        if shouldFailUpdateStartup {
            throw errorToThrow
        }
        
        if let index = mockStartups.firstIndex(where: { $0.documentId == request.documentId }) {
            let updatedStartup = StartupItem(
                id: mockStartups[index].id,
                documentId: request.documentId,
                title: request.title,
                description: request.description,
                image: request.imageData != nil ? "updated-image.jpg" : mockStartups[index].image,
                category: mockStartups[index].category,
                location: request.location,
                ownerEmail: mockStartups[index].ownerEmail
            )
            mockStartups[index] = updatedStartup
            return updatedStartup
        }
        
        return StartupItem(
            id: Int.random(in: 1...1000),
            documentId: request.documentId,
            title: request.title,
            description: request.description,
            image: request.imageData != nil ? "updated-image.jpg" : nil,
            category: "Tech",
            location: request.location,
            ownerEmail: "test@test.com"
        )
    }
    
    func deleteStartup(documentId: String) async throws -> Bool {
        deleteStartupCallCount += 1
        lastDeleteStartupDocumentId = documentId
        
        if shouldFailDeleteStartup {
            throw errorToThrow
        }
        
        mockStartups.removeAll { $0.documentId == documentId }
        
        return true
    }
}
