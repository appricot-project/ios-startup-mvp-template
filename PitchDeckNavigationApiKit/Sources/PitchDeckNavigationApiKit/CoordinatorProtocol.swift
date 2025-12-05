//
//  CoordinatorProtocol.swift
//  PitchDeckNavigationKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import Foundation
import SwiftUI

public protocol CoordinatorProtocol: ObservableObject {
    associatedtype Route: Hashable

    var path: NavigationPath { get set }

    func push(_ route: Route)
    func pop()
    func popToRoot()
}
