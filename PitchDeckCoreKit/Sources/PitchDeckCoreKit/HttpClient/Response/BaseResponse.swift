//
//  BaseResponse.swift
//  PitchDeckCoreKit
//
//  Created by Anatoly Nevmerzhitsky on 05.12.2025.
//

import Foundation

final class BaseResponse: Codable, Sendable {
    
    // MARK: - Public properties
    
    public let code: Int?
    public let msgCode: String?
    public let msg: String?
    
    // MARK: - Init
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.msgCode = try? container.decodeIfPresent(String.self, forKey: .msgCode)
        self.msg = try? container.decodeIfPresent(String.self, forKey: .msg)
        self.code = try? container.decodeIfPresent(Int.self, forKey: .code)
    }
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case code
        case msgCode
        case msg
    }
}
