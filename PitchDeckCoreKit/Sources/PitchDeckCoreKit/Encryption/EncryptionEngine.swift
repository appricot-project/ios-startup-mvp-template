//
//  EncryptionEngine.swift
//  PitchDeckCoreKit
//
//  Created by Anton Redkozubov on 12.12.2025.
//

import Foundation

public struct EncryptedData {
    let data: Data

    public init(data: Data) {
        self.data = data
    }

    public init?(base64String string: String) {
        guard let stringWithoutPercent = string.removingPercentEncoding else { return nil }
        guard let data = Data(base64Encoded: stringWithoutPercent,
                              options: .ignoreUnknownCharacters) else { return nil }
        self.data = data
    }

    var base64String: String {
        return data
            .base64EncodedString(options: .endLineWithLineFeed)
            .addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)!
    }
}

public struct Key {
    let data: Data

    public init(data: Data) {
        self.data = data
    }

    public init?(string: String) {
        guard let data = string.data(using: .utf8) else { return nil }
        self.data = data
    }

    init?(base64String string: String) {
        guard let stringWithoutPercent = string.removingPercentEncoding else { return nil }
        
        guard let data = Data(base64Encoded: stringWithoutPercent,
                              options: .ignoreUnknownCharacters) else { return nil }

        self.data = data
    }

    var base64String: String {
        return data
            .base64EncodedString(options: .endLineWithLineFeed)
            .addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)!
    }
    var utf8String: String? {
        return String(data: data, encoding: .utf8)
    }
}

enum EncryptionError: Error {
    case cantCreateEncryptor
    case cantEncryptMessage
    case cantDecryptMessage
    case cantEncodeMessage
}

public final class EncryptionEngine: Sendable {
    public static let sharedInstance = EncryptionEngine()
    private init() {}
}
