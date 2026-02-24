//
//  ApolloClient.swift
//  PitchDeckCoreKit
//
//  Created by Anton Redkozubov on 15.12.2025.
//

import Foundation
import Apollo
import ApolloAPI

@MainActor
public final class ApolloWebClient {
    
    public static let shared = ApolloWebClient()
    
    // MARK: - Private properties
    
    private var client: ApolloClient?
    
    // MARK: - Public API
    
    public var apollo: ApolloClient {
        if let client {
            return client
        }
        
        let newClient = makeClient()
        client = newClient
        return newClient
    }
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Private helpers
    
    private func makeClient() -> ApolloClient {
        let urlString = Config.strapiURL ?? "https://localhost:1337/graphql"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid GraphQL URL: \(urlString)")
        }
        let authToken: String? = Config.strapiAuthToken
        
        let store = ApolloStore()
        let sessionConfiguration = URLSessionConfiguration.default
        var headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if let token = authToken, !token.isEmpty {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        sessionConfiguration.httpAdditionalHeaders = headers
        
        let urlSession = URLSession(configuration: sessionConfiguration)
        let interceptorProvider = SimpleInterceptorProvider(
            urlSession: urlSession,
            store: store
        )
        
        let networkTransport = RequestChainNetworkTransport(
            urlSession: urlSession,
            interceptorProvider: interceptorProvider,
            store: store,
            endpointURL: url
        )
        
        return ApolloClient(
            networkTransport: networkTransport,
            store: store
        )
    }
}

// MARK: - SimpleInterceptorProvider

private final class SimpleInterceptorProvider: InterceptorProvider {
    
    private let urlSession: URLSession
    private let store: ApolloStore
    
    init(urlSession: URLSession, store: ApolloStore) {
        self.urlSession = urlSession
        self.store = store
    }
    
    func interceptors<Operation: ApolloAPI.GraphQLOperation>(
        for operation: Operation
    ) -> [Any] {
        return []
    }
    
    func shouldInvalidateClientOnDeinit() -> Bool {
        return true
    }
}
