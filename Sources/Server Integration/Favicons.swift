//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/08/2024.
//

import CoenttbShared
import Coenttb_Web_HTML
import Dependencies
import Foundation

extension Favicons {
    package static var coenttb: Self {

        @Dependency(\.coenttb.website.router) var router

        return .init(
            icon: .init(
                lightMode: router.url(for: .public(.asset(.logo(.favicon_dark)))),
                darkMode: router.url(for: .public(.asset(.logo(.favicon_light))))
            ),
            apple_touch_icon: router.url(for: .public(.asset(.logo(.favicon_light)))).relativeString,
            manifest: "",
            maskIcon: ""
        )
    }
}
