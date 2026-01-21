//
//  StartupServiceImpl.swift
//  PitchDeckMainKit
//
//  Created by Anton Redkozubov on 22.12.2025.
//

import Foundation
import Apollo
import PitchDeckCoreKit
import PitchDeckStartupApi
import PitchDeckMainApiKit

@MainActor
public final class StartupServiceImpl: StartupService {
    
    public init() {}
    
    public func getStartup(documentId: String) async throws -> StartupItem {
        let query = StartupQuery(
            documentId: documentId
        )
        
        let result = try await ApolloWebClient.shared.apollo.fetch(query: query)
        
        guard let startup = result.data?.startup else {
            throw NSError(domain: "No data", code: -1)
        }
        
        return StartupItem(
            id: startup.startupId ?? 0,
            documentId: startup.documentId,
            title: startup.title ?? "",
            description: startup.description ?? "",
            image: (Config.strapiDataURL ?? "") + (startup.imageURL?.url ?? ""),
            category: startup.category?.title ?? "",
            location: startup.location ?? ""
        )
    }
    
    public func getStartups(
        title: String? = nil,
        categoryId: Int? = nil,
        page: Int,
        pageSize: Int
    ) async throws -> StartupPageResult {
        let titleFilter: GraphQLNullable<StringFilterInput> = {
            if let title = title, !title.isEmpty {
                return .some(StringFilterInput(contains: .some(title)))
            } else {
                return .none
            }
        }()
        let categoryFilter: GraphQLNullable<StartupCategoryFiltersInput> = {
            if let categoryId = categoryId {
                return .some(StartupCategoryFiltersInput(
                    categoryId: .some(IntFilterInput(eq: .some(Int32(categoryId))))
                ))
            } else {
                return .none
            }
        }()
        
        let filters = StartupFiltersInput(
            title: titleFilter,
            category: categoryFilter
        )
        
        let query = StartupsQuery(
            filters: .some(filters),
            page: .some(Int32(page)),
            pageSize: .some(Int32(pageSize))
        )
        
        let result = try await ApolloWebClient.shared.apollo.fetch(query: query)
        
        let connection = result.data?.startups_connection
        
        let items = connection?.nodes.compactMap { startup -> StartupItem? in
            return StartupItem(
                id: Int(startup.startupId ?? 0),
                documentId: startup.documentId,
                title: startup.title ?? "",
                description: startup.description,
                image: (Config.strapiDataURL ?? "") + (startup.imageURL?.url ?? ""),
                category: startup.category?.title ?? "",
                location: startup.location ?? ""
            )
        } ?? []
        
        let graphQLPageInfo = connection?.pageInfo

        let appPageInfo: PageInfo? = graphQLPageInfo.map { item in
            PageInfo(
                page: Int(item.page),
                pageSize: Int(item.pageSize),
                pageCount: Int(item.pageCount),
                total: Int(item.total)
            )
        }

        return StartupPageResult(
            items: items,
            pageInfo: appPageInfo
        )
    }
    
    public func getStartupsCategories() async throws -> [CategoryItem] {
        let query = StartupCategoriesQuery()
        let result = try await ApolloWebClient.shared.apollo.fetch(query: query)
        
        return result.data?.startupCategories.compactMap { category in
            PitchDeckMainApiKit.CategoryItem(
                id: category?.categoryId ?? 0,
                title: category?.title ?? "",
            )
        } ?? []
    }
}
