//
//  EncryptionEngine+ProtectData.swift
//  PitchDeckCoreKit
//
//  Created by Anton Redkozubov on 12.12.2025.
//

import Foundation
import themis

// MARK: - Encrypt/Decrypt Data

extension EncryptionEngine {

    public func encryptMessage(message: String, secretKey: Key) throws -> EncryptedData {
        // 1. create encryptor SecureCell with own secret key
        guard let cellSeal = TSCellSeal(key: secretKey.data) else {
            print("Failed to encrypt message: error occurred while initializing object cellSeal")
            throw EncryptionError.cantCreateEncryptor
        }

        // 2. encrypt data
        let encryptedMessage: Data
        do {
            encryptedMessage = try cellSeal.encrypt(message.data(using: .utf8)!,
                                                    context: nil)
        } catch let error as NSError {
            print("Failed to encrypt post: error occurred while encrypting message \(error)")
            throw EncryptionError.cantEncryptMessage
        }
        return EncryptedData(data: encryptedMessage)
    }

    public func decryptMessage(encryptedMessage: EncryptedData, secretKey: Key) throws -> String {
        // 1. create decryptor with own secret key
        guard let cellSeal = TSCellSeal(key: secretKey.data) else {
            print("Failed to decrypt message: error occurred while initializing object cellSeal")
            throw EncryptionError.cantCreateEncryptor
        }

        // 2. decrypt encryptedMessage
        var decryptedMessage: Data = Data()
        do {
            decryptedMessage = try cellSeal.decrypt(encryptedMessage.data,
                                                    context: nil)
        } catch let error as NSError {
            print("2 Failed to decrypt message: error occurred while decrypting: \(error)")
            throw EncryptionError.cantDecryptMessage
        }

        // 3. encode decrypted message from Data to String
        guard let decryptedBody = String(data: decryptedMessage, encoding: .utf8) else {
            print("Failed to decrypt message: error occurred while encoding decrypted post body")
            throw EncryptionError.cantEncodeMessage
        }
        return decryptedBody
    }

    public func encondingData(api: String, key: String) -> String {
        let encKey = Key(string: key)!
        let encryptedMessage = EncryptedData(base64String: api)
        var decryptedMessage = ""
        do {
            decryptedMessage = try self.decryptMessage(encryptedMessage: encryptedMessage!, secretKey: encKey)
        } catch {}
        return decryptedMessage
    }
}
