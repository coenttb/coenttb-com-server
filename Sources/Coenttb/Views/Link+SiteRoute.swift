//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/08/2024.
//

import Coenttb_Server_HTML
import Dependencies
import Foundation
import Server_Router

extension Link {
    package init(destination: WebsitePage, @HTMLBuilder label: () -> Label) {
        @Dependency(\.serverRouter) var serverRouter
        @Dependency(\.language) var language
        self.init(href: serverRouter.path(for: .website(.init(language: language, page: destination))), label: label)
    }

    package init(
        destination: WebsitePage,
        _ title: String
    ) where Label == HTMLText {
        @Dependency(\.serverRouter) var serverRouter
        @Dependency(\.language) var language
        self.init(title, href: serverRouter.path(for: .website(.init(language: language, page: destination))))
    }
}
