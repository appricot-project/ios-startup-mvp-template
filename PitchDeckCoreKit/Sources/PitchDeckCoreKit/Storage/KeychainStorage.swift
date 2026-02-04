//
//  KeychainStorage.swift
//  PitchDeckCoreKit
//
//  Created by Anatoly Nevmerzhitsky on 08.12.2025.
//

import Foundation
import Security
import CryptoKit

public final class KeychainStorage: LocalStorage, @unchecked Sendable {
    
    // MARK: - Private properties
    
    private let keychainWrapper = KeychainWrapper.shared
    
    public init() { }
    
    // MARK: - LocalStorage
    
    public func string(forKey key: LocalStorageKey) async -> String {
        return await keychainWrapper.string(for: key.rawValue) ?? ""
    }
    
    public func set(_ value: String, forKey key: LocalStorageKey) async {
        await keychainWrapper.setString(value, forKey: key.rawValue)
    }
    
    public func bool(forKey key: LocalStorageKey) async -> Bool {
        return await keychainWrapper.bool(for: key.rawValue) ?? false
    }
    
    public func set(_ value: Bool, forKey key: LocalStorageKey) async {
        await keychainWrapper.setBool(value, forKey: key.rawValue)
    }
    
    public func integer(forKey key: LocalStorageKey) async -> Int {
        return await keychainWrapper.int(for: key.rawValue) ?? 0
    }
    
    public func set(_ value: Int, forKey key: LocalStorageKey) async {
        await keychainWrapper.setInt(value, forKey: key.rawValue)
    }
    
    public func double(forKey key: LocalStorageKey) async -> Double {
        return await keychainWrapper.double(for: key.rawValue) ?? 0
    }
    
    public func set(_ value: Double, forKey key: LocalStorageKey) async {
        await keychainWrapper.setDouble(value, forKey: key.rawValue)
    }
    
    public func date(forKey key: LocalStorageKey) async -> Date {
        let timestamp = await keychainWrapper.double(for: key.rawValue) ?? 0.0
        return Date(timeIntervalSince1970: timestamp)
    }
    
    public func set(_ value: Date, forKey key: LocalStorageKey) async {
        await keychainWrapper.setDouble(value.timeIntervalSince1970, forKey: key.rawValue)
    }
    
    public func array(forKey key: LocalStorageKey) async -> [Any] {
        return []
        //            return await keychainWrapper.array(forKey: key.rawValue)
    }
    
    public func set(_ value: [Any], forKey key: LocalStorageKey) async {
//        await keychainWrapper.setArray(value, forKey: key.rawValue)
    }
    
    public func dictionary(forKey key: LocalStorageKey) async -> [String : Any] {
        return [:]
        //            return await keychainWrapper.dictionary(forKey: key.rawValue)
    }
    
    public func set(_ value: [String : Any], forKey key: LocalStorageKey) async {
//        await keychainWrapper.setDictionary(value, forKey: key.rawValue)
    }
    
    public func remove(forKey key: LocalStorageKey) async {
        await keychainWrapper.remove(key: key.rawValue)
    }
}

