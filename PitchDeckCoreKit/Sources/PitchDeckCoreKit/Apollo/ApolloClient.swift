//
//  ApolloClient.swift
//  PitchDeckCoreKit
//
//  Created by Anton Redkozubov on 15.12.2025.
//

import Foundation
import Apollo

@MainActor
public class ApolloWebClient {
    
    public static let shared = ApolloWebClient()
    
    // MARK: - Private properties
    
    private var baseUrl: String
    private(set) var apollo: ApolloClient = {
        let url = URL(string: Config.strapiURL ?? "")!
        return ApolloClient(url: url)
    }()
    
    public init(baseUrl: String = Config.strapiURL ?? "") {
        self.baseUrl = baseUrl
    }
    
//    public func apollo() -> ApolloClient {
//        let url = URL(string: baseUrl)!
//        return ApolloClient(url: url)
//    }
    
}
