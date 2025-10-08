//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/09/2024.
//

import Coenttb_Web_HTML
import Foundation

extension PageModule.Theme {
    package static var mainContent: Self {
        Self(
            topMargin: .rem(4),
            bottomMargin: .rem(4),
            leftRightMargin: .rem(2),
            leftRightMarginDesktop: .rem(5)
        )
    }
}

extension PageModule.Theme {
    package static var sidebarContent: Self {
        Self(
            topMargin: .rem(4),
            bottomMargin: .rem(4),
            leftRightMargin: .rem(2),
            leftRightMarginDesktop: .rem(4)
        )
    }
}
