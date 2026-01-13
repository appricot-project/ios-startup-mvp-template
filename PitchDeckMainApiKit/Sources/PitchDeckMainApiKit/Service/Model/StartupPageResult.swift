//
//  StartupPageResult.swift
//  PitchDeckMainApiKit
//
//  Created by Anton Redkozubov on 12.01.2026.
//

import Foundation

public struct StartupPageResult: Equatable, Sendable {
    public let items: [StartupItem]
    public let pageInfo: PageInfo?
    
    public init(items: [StartupItem], pageInfo: PageInfo?) {
        self.items = items
        self.pageInfo = pageInfo
    }
}
