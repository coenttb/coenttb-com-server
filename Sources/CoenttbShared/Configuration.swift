//
//  File.swift
//  coenttb-com-shared
//
//  Created by Coen ten Thije Boonkkamp on 24/01/2025.
//

import CoenttbRouter
import Coenttb_Server
import Dependencies
import Foundation

public struct Configuration: Sendable {
    public var website: Configuration.Website

    public init(
        website: Website
    ) {
        self.website = website
    }
}

extension Configuration {
    public struct Website: Sendable {
        public var baseURL: URL
        public var router: Coenttb_Com_Router.Route.Router

        public init(
            baseURL: URL,
            router: Coenttb_Com_Router.Route.Router
        ) {
            self.baseURL = baseURL
            self.router = router
        }
    }
}

extension Configuration: DependencyKey {
    public static var liveValue: Self {
        .init(
            website: .liveValue
        )
    }

    public static var testValue: Self {
        .init(
            website: .testValue
        )
    }
}

extension Configuration.Website: TestDependencyKey {
    public static var liveValue: Self {
        let baseURL = URL(string: "https://coenttb.com")!
        return .init(
            baseURL: baseURL,
            router: Coenttb_Com_Router.Route.Router(baseURL)
        )
    }

    public static var testValue: Self {
        let baseURL = URL(string: "http://localhost:8080")!
        return .init(
            baseURL: baseURL,
            router: Coenttb_Com_Router.Route.Router(baseURL)
        )
    }
}

extension DependencyValues {
    public var coenttb: Configuration {
        get { self[Configuration.self] }
        set { self[Configuration.self] = newValue }
    }
}
