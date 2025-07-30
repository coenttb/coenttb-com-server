//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 11/03/2025.
//

import Dependencies
import DependenciesMacros

extension Client {
    @DependencyClient
    package struct User: Sendable {

        package init(

        ) {

        }
    }
}

extension Client.User: TestDependencyKey {
    package static var testValue: Self {
        .init()
    }
}
