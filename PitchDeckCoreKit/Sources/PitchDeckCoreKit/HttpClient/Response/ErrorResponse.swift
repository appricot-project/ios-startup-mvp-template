//
//  ErrorResponse.swift
//  PitchDeckCoreKit
//
//  Created by Anatoly Nevmerzhitsky on 05.12.2025.
//

import Foundation

struct ErrorResponse: Codable, Error {
    let message: String?
    let code: Int?
}
