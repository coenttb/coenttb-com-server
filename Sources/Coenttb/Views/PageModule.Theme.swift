//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/09/2024.
//

import CoenttbWebHTML
import Foundation

extension PageModule.Theme {
    public static var mainContent: Self {
        Self(
            topMargin: 4.rem,
            bottomMargin: 4.rem,
            leftRightMargin: 2.rem,
            leftRightMarginDesktop: 5.rem
        )
    }
}

extension PageModule.Theme {
    public static var sidebarContent: Self {
        Self(
            topMargin: 4.rem,
            bottomMargin: 4.rem,
            leftRightMargin: 2.rem,
            leftRightMarginDesktop: 4.rem
        )
    }
}
