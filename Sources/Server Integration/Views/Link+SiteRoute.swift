//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/08/2024.
//

import Coenttb_Com_Router
import Coenttb_Com_Shared
import Coenttb_Web_HTML
import Dependencies
import Foundation

extension CoenttbHTML.Link {
    package init(destination: Coenttb_Com_Router.Route.Website, @HTMLBuilder label: () -> Label) {
        @Dependency(\.coenttb.website.router) var router
        @Dependency(\.language) var language
        self.init(
            href: .init(router.path(for: .website(.init(language: language, page: destination)))),
            label: label
        )
    }

    package init(
        destination: Coenttb_Com_Router.Route.Website,
        _ title: String
    ) where Label == HTMLText {
        @Dependency(\.coenttb.website.router) var router
        @Dependency(\.language) var language
        self.init(
            title,
            href: .init(router.path(for: .website(.init(language: language, page: destination))))
        )
    }
}
