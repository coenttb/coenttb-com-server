//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 18-12-2023.
//

import Dependencies
import Foundation

private enum CurrentRouteKey: DependencyKey {
    static let liveValue: ServerRoute = .website(.init(page: .home))
    static let testValue: ServerRoute = .website(.init(page: .home))
}

extension DependencyValues {
    public var route: ServerRoute {
        get { self[CurrentRouteKey.self] }
        set { self[CurrentRouteKey.self] = newValue }
    }
}
