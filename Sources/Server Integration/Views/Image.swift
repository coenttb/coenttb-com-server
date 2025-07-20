//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 01/09/2024.
//

import Coenttb_Com_Shared
import CoenttbHTML
import Dependencies
import Foundation

extension HTMLElementTypes.Image {
    package static let coenttbGreenSuit: HTMLElementTypes.Image = {
        @Dependency(\.coenttb.website.router) var serverRouter
        return Image(
            src: .init(serverRouter.href(for: .asset(.image("coenttb-halftone.png")))),
            alt: "coenttb avatar"
        )
    }()

    package static let prehalftone: HTMLElementTypes.Image = {
        @Dependency(\.coenttb.website.router) var serverRouter
        return Image(
            src: .init(serverRouter.href(for: .asset(.image("prehalftone.png")))),
            alt: "prehalftone"
        )
    }()
}
