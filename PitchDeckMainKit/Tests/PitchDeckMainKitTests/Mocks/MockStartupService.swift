//
//  MockStartupService.swift
//  PitchDeckMainKitTests
//
//  Created by Anton Redkozubov on 20.01.2026.
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
    var errorToThrow: Error = NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
    
    // MARK: - Call tracking
    
    var getStartupCallCount = 0
    var getStartupsCallCount = 0
    var getStartupsCategoriesCallCount = 0
    
    var lastGetStartupDocumentId: String?
    var lastGetStartupsTitle: String?
    var lastGetStartupsCategoryId: Int?
    var lastGetStartupsPage: Int?
    var lastGetStartupsPageSize: Int?
    
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
    
    func getStartups(title: String?, categoryId: Int?, page: Int, pageSize: Int) async throws -> StartupPageResult {
        getStartupsCallCount += 1
        lastGetStartupsTitle = title
        lastGetStartupsCategoryId = categoryId
        lastGetStartupsPage = page
        lastGetStartupsPageSize = pageSize
        
        if shouldFailGetStartups {
            throw errorToThrow
        }
        
        // Simulate pagination
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
    
    // MARK: - Helper methods
    
    func reset() {
        mockStartups = []
        mockCategories = []
        mockStartupDetail = nil
        mockPageInfo = nil
        
        shouldFailGetStartup = false
        shouldFailGetStartups = false
        shouldFailGetCategories = false
        
        getStartupCallCount = 0
        getStartupsCallCount = 0
        getStartupsCategoriesCallCount = 0
        
        lastGetStartupDocumentId = nil
        lastGetStartupsTitle = nil
        lastGetStartupsCategoryId = nil
        lastGetStartupsPage = nil
        lastGetStartupsPageSize = nil
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
                location: "City \(index + 1)"
            )
        }
    }
    
    static func createMockCategoryItems(count: Int) -> [CategoryItem] {
        return (0..<count).map { index in
            CategoryItem(
                id: index + 1,
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
}
