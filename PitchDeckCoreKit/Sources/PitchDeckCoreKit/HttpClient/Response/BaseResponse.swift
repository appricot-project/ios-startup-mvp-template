//
//  BaseResponse.swift
//  PitchDeckCoreKit
//
//  Created by Anatoly Nevmerzhitsky on 05.12.2025.
//

import Foundation

open class BaseResponse: Codable {
    
    // MARK: - Public properties
    
    public var code: Int?
    public var msgCode: String?
    public var msg: String?
    
    // MARK: - Init
    
    public init() {}
    
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
