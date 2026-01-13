//
//  RequestInterceptor.swift
//  PitchDeckCoreKit
//
//  Created by Anatoly Nevmerzhitsky on 05.12.2025.
//

import Foundation
import Alamofire

final class RequestInterceptor: Alamofire.RequestInterceptor {

    init() {}

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        request.setValue("Bearer token", forHTTPHeaderField: "Authorization")
        completion(.success(request))
    }

    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        if let response = request.task?.response as? HTTPURLResponse,
           response.statusCode == 401 {
            completion(.retry)
        } else {
            completion(.doNotRetry)
        }
    }
}
