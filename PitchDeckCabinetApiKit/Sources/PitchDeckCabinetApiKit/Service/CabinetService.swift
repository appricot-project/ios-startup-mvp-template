//
//  CabinetService.swift
//  PitchDeckCabinetApiKit
//
//  Created by Anton Redkozubov on 03.02.2026.
//

import Foundation
import PitchDeckMainApiKit

public protocol CabinetService: Sendable {
    func getUserProfile() async throws -> UserProfileData
}
