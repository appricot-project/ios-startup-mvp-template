//
//  PageInfo.swift
//  PitchDeckMainApiKit
//
//  Created by Anton Redkozubov on 12.01.2026.
//

import Foundation

public struct PageInfo: Equatable, Sendable {
    public let page: Int
    public let pageSize: Int
    public let pageCount: Int
    public let total: Int
    
    public init(page: Int, pageSize: Int, pageCount: Int, total: Int) {
        self.page = page
        self.pageSize = pageSize
        self.pageCount = pageCount
        self.total = total
    }
}
