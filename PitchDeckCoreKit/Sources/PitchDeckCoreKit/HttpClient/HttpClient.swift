//
//  HttpClient.swift
//  PitchDeckCoreKit
//
//  Created by Anatoly Nevmerzhitsky on 05.12.2025.
//

import Foundation
import Alamofire

open class HttpClient {
    
    // MARK: - Private properties
    
    private var baseUrl: String
    private let dateFormatter = DateFormatter()
    private let decoder = JSONDecoder()
    private let session: Session
    private let interceptor = RequestInterceptor()

    // MARK: - Public init
    
    public init(baseUrl: String = "") {
        self.baseUrl = baseUrl
        self.session = Session()
    }
    
    public func request<T: Decodable & Sendable>(path: String, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) async throws -> T {
        let response = session
            .request(baseUrl + path, method: method, parameters: parameters, encoding: encoding, headers: headers)
                   .validate()
                   .serializingDecodable(T.self, decoder: decoder)
        do {
            let value = try await response.value
            return value
        } catch {
            throw error
        }
    }
}
