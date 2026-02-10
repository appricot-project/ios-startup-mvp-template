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
import ApolloAPI

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
            id: Int(startup.documentId.hashValue),
            documentId: startup.documentId,
            title: startup.title ?? "",
            description: startup.description ?? "",
            image: (Config.strapiDataURL ?? "") + (startup.imageURL?.url ?? ""),
            category: startup.category?.title ?? "",
            location: startup.location ?? "",
            ownerEmail: startup.ownerEmail ?? ""
        )
    }
    
    public func getStartups(
        title: String? = nil,
        categoryId: Int? = nil,
        email: String? = nil,
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
                    categoryId: .some(IntFilterInput(eq: .some(Int32(clamping: categoryId))))
                ))
            } else {
                return .none
            }
        }()
        
        let emailFilter: GraphQLNullable<StringFilterInput> = {
            if let email = email, !email.isEmpty {
                return .some(StringFilterInput(eq: .some(email)))
            } else {
                return .none
            }
        }()
        
        let filters = StartupFiltersInput(
            title: titleFilter,
            category: categoryFilter,
            ownerEmail: emailFilter
        )
        
        let query = StartupsQuery(
            filters: .some(filters),
            page: .some(Int32(clamping: page)),
            pageSize: .some(Int32(clamping: pageSize))
        )
        
        let result = try await ApolloWebClient.shared.apollo.fetch(query: query)
        
        let connection = result.data?.startups_connection
        
        let items = connection?.nodes.compactMap { startup -> StartupItem? in
            return StartupItem(
                id: Int(startup.documentId.hashValue),
                documentId: startup.documentId,
                title: startup.title ?? "",
                description: startup.description,
                image: (Config.strapiDataURL ?? "") + (startup.imageURL?.url ?? ""),
                category: startup.category?.title ?? "",
                location: startup.location ?? "",
                ownerEmail: startup.ownerEmail ?? ""
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
        
        return result.data?.startupCategories.compactMap { (categoryOptional) -> CategoryItem? in
            guard let category = categoryOptional,
                  let categoryId = category.categoryId,
                  let title = category.title else {
                return nil
            }
            let documentId = category.documentId
            return CategoryItem(
                id: categoryId,
                documentId: documentId,
                title: title
            )
        } ?? []
    }
    
    private func uploadImageToMedia(imageData: Data) async throws -> String {
        let urlString = "\(Config.strapiDataURL ?? "")/api/upload"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"files\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        do {
            let accessToken = Config.strapiAuthToken
            if let token = accessToken, !token.isEmpty {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                throw NSError(domain: "No auth token", code: -1)
            }
        } catch {
            throw NSError(domain: "Keychain error", code: -1)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]],
           let firstItem = jsonArray.first,
           let id = firstItem["id"] as? Int {
            return String(id)
        }
        
        throw NSError(domain: "Upload failed", code: -1, userInfo: [
            "response": String(data: data, encoding: .utf8) ?? "non-utf8",
            "status": String((response as? HTTPURLResponse)?.statusCode ?? 0)
        ])
    }
    
    public func createStartup(request: CreateStartupRequest) async throws -> StartupItem {
        var imageUrlId: String = ""
        
        if let imageData = request.imageData {
            imageUrlId = try await uploadImageToMedia(imageData: imageData)
        }
        
        let mutation = CreateStartupMutation(
            ownerEmail: request.ownerEmail,
            title: request.title,
            description: request.description,
            location: request.location,
            categoryId: ID(String(request.categoryId)),
            imageURL: imageUrlId.isEmpty ? .none : .some(ID(imageUrlId))
        )

        let result = try await ApolloWebClient.shared.apollo.perform(mutation: mutation)

        guard let createdStartup = result.data?.createStartup else {
            throw NSError(domain: "No data", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create startup"])
        }

        return StartupItem(
            id: Int(createdStartup.documentId.hashValue),
            documentId: createdStartup.documentId,
            title: createdStartup.title ?? "",
            description: createdStartup.description ?? "",
            image: (Config.strapiDataURL ?? "") + (createdStartup.imageURL?.url ?? ""),
            category: createdStartup.category?.title ?? "",
            location: createdStartup.location ?? "",
            ownerEmail: createdStartup.ownerEmail ?? ""
        )
    }
    
    public func updateStartup(request: UpdateStartupRequest) async throws -> StartupItem {
        var imageUrlId: String = ""
        
        if let imageData = request.imageData {
            imageUrlId = try await uploadImageToMedia(imageData: imageData)
        }
        
        let mutation = UpdateStartupMutation(
            documentId: ID(request.documentId),
            title: request.title,
            description: request.description,
            location: request.location,
            categoryId: ID(request.categoryId),
            imageURL: imageUrlId.isEmpty ? GraphQLNullable<ID>.none : GraphQLNullable<ID>.some(ID(imageUrlId))
        )

        let result = try await ApolloWebClient.shared.apollo.perform(mutation: mutation)

        guard let updatedStartup = result.data?.updateStartup else {
            throw NSError(domain: "No data", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to update startup"])
        }

        return StartupItem(
            id: Int(updatedStartup.documentId.hashValue),
            documentId: updatedStartup.documentId,
            title: updatedStartup.title ?? "",
            description: updatedStartup.description ?? "",
            image: (Config.strapiDataURL ?? "") + (updatedStartup.imageURL?.url ?? ""),
            category: updatedStartup.category?.title ?? "",
            location: updatedStartup.location ?? "",
            ownerEmail: updatedStartup.ownerEmail ?? ""
        )
    }
}
