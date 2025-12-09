//
//  LocalStorage.swift
//  PitchDeckCoreKit
//
//  Created by Anatoly Nevmerzhitsky on 08.12.2025.
//

import Foundation

public protocol LocalStorage {
    
    func string(forKey key: LocalStorageKey) async -> String
    func set(_ value: String, forKey key: LocalStorageKey) async
    func bool(forKey key: LocalStorageKey) async -> Bool
    func set(_ value: Bool, forKey key: LocalStorageKey) async
    func integer(forKey key: LocalStorageKey) async -> Int
    func set(_ value: Int, forKey key: LocalStorageKey) async
    func double(forKey key: LocalStorageKey) async -> Double
    func set(_ value: Double, forKey key: LocalStorageKey) async
    func date(forKey key: LocalStorageKey) async -> Date
    func set(_ value: Date, forKey key: LocalStorageKey) async
    func array(forKey key: LocalStorageKey) async -> [Any]
    func set(_ value: [Any], forKey key: LocalStorageKey) async
    func dictionary(forKey key: LocalStorageKey) async -> [String : Any]
    func set(_ value: [String : Any], forKey key: LocalStorageKey) async
    func remove(forKey key: LocalStorageKey) async
}
