//
//  BaseCoordinator.swift
//  PitchDeckNavigationApiKit
//
//  Created by Anton Redkozubov on 05.12.2025.
//

import Foundation
import SwiftUI

open class BaseCoordinator<R: Hashable>: CoordinatorProtocol {

    public typealias Route = R

    @Published public var path = NavigationPath()

    public init() {}

    open func push(_ route: Route) {
        path.append(route)
    }

    open func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    open func popToRoot() {
        path = NavigationPath()
    }
}
