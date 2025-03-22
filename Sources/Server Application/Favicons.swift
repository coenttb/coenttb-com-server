//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/08/2024.
//

import Dependencies
import Favicon
import Foundation
import Coenttb_Com_Shared

extension Favicons {
    package static var coenttb: Self {

        @Dependency(\.coenttb.website.router) var serverRouter

        return .init(
            icon: .init(
                lightMode: serverRouter.url(for: .public(.asset(.logo(.favicon_dark)))),
                darkMode: serverRouter.url(for: .public(.asset(.logo(.favicon_light))))
            ),
            apple_touch_icon: serverRouter.url(for: .public(.asset(.logo(.favicon_light)))).relativeString,
            manifest: "",
            maskIcon: ""
        )
    }
}
