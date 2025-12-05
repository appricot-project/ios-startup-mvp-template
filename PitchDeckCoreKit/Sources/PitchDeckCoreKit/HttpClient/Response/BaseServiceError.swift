//
//  BaseServiceError.swift
//  PitchDeckCoreKit
//
//  Created by Anatoly Nevmerzhitsky on 05.12.2025.
//

import Foundation
import Alamofire

public enum BaseServiceError: Error, Equatable {
    case unauthorized
    case custom(String)
}

extension BaseServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Auth error"
        case .custom(let message):
            return message
        }
    }
}

extension BaseServiceError {
    public init(data: Data) {
        let decoder = JSONDecoder()
        if let decodedData = try? decoder.decode(BaseResponse.self, from: data) {
            switch decodedData.msgCode {
            case "auth.error":
                self = BaseServiceError.unauthorized
            default:
                self = .custom((decodedData.msg ?? ""))
            }
        }
        else {
            self = .custom("Connection Error")
        }
    }
}
