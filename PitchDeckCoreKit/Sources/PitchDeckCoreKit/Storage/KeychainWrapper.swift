//
//  KeychainWrapper.swift
//  PitchDeckCoreKit
//
//  Created by Anatoly Nevmerzhitsky on 09.12.2025.
//

import Foundation
import Security

public actor KeychainWrapper {
    
    public static let shared = KeychainWrapper()
    private init() {}
    
    // MARK: - Save
    
    private func save(_ data: Data, key: String) {
        let query: [String : Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    // MARK: - Load
    
    private func load(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess {
            return item as? Data
        }
        return nil
    }
    
    // MARK: - Delete
    
    public func remove(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - Extension for genegics

extension KeychainWrapper {
    
    // MARK: - Set
    
    public func set<T: Codable>(_ value: T, for key: String) async {
        do {
            let data = try JSONEncoder().encode(value)
            return save(data, key: key)
        } catch {
            print("Encoding error: \(error)")
        }
    }
    
    public func value<T: Codable>(for key: String, as type: T.Type) async -> T? {
        guard let data = load(key: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - Helpers
    
    public func setBool(_ value: Bool, forKey key: String) async {
        await set(value, for: key)
    }
    
    public func bool(for key: String) async -> Bool? {
        await value(for: key, as: Bool.self)
    }
    
    public func setInt(_ value: Int, forKey key: String) async {
        await set(value, for: key)
    }
    
    public func int(for key: String) async -> Int? {
        await value(for: key, as: Int.self)
    }
    
    public func setDouble(_ value: Double, forKey key: String) async {
        await set(value, for: key)
    }
    
    public func double(for key: String) async -> Double? {
        await value(for: key, as: Double.self)
    }
    
    public func setString(_ value: String, forKey key: String) async {
        await set(value, for: key)
    }
    
    public func string(for key: String) async -> String? {
        await value(for: key, as: String.self)
    }
    
    public func setDictionary(_ value: [String : Any], forKey key: String) async {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true) else { return }
        await set(data, for: key)
    }
    
    public func dictionary(forKey key: String) async -> [String : Any] {
        guard let data = load(key: key) else { return [:] }
        guard let unarchvedData = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self, from: data) as? [String: Any]
        else { return [:] }
        return unarchvedData
    }
    
    public func setArray(_ value: [Any], forKey key: String) async {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true) else { return }
        await set(data, for: key)
    }
    
    public func array(forKey key: String) -> [Any] {
        guard let data = load(key: key) else { return [] }
        guard let unarchvedData = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: data) as? [Any]
        else { return [] }
        return unarchvedData
    }
    
    public func setData(_ data: Data, forKey key: String) async {
        await set(data, for: key)
    }
    
    public func data(forKey key: String) -> Data? {
        load(key: key)
    }
    
    public func remove(_ key: String) async {
        remove(key: key)
    }
}
