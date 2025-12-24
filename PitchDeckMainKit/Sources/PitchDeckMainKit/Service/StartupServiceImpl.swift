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
    
    public func startups(title: String? = nil, page: Int, pageSize: Int) async throws -> [StartupItem] {
        
        let titleFilter: GraphQLNullable<StringFilterInput>
        if let title {
            titleFilter = .some(StringFilterInput(contains: .some(title)))
        } else {
            titleFilter = .none
        }
        
        let filters = StartupFiltersInput(
               title: titleFilter
           )
        
        let query = StartupsQuery(
            filters: .some(filters),
            page: .some(Int32(page)),
            pageSize: .some(Int32(pageSize))
        )
        let result = try await ApolloWebClient.shared.apollo.fetch(query: query)
        
        return result.data?.startups.compactMap { startup in
            PitchDeckMainApiKit.StartupItem(
                id: startup?.startupId ?? 0,
                title: startup?.title ?? "",
                description: startup?.description ?? "",
                image: startup?.imageURL?.url ?? "",
                category: startup?.category?.title ?? "",
                location: startup?.location ?? ""
            )
        } ?? []
    }
    
    public func startupsCategoris() async throws -> [CategoryItem] {
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
