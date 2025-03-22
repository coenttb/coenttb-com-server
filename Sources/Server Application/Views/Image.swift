//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 01/09/2024.
//

import CoenttbHTML
import Dependencies
import Foundation
import Coenttb_Com_Shared

extension Image {
    nonisolated(unsafe)
    package static let coenttbGreenSuit: Image = {
        @Dependency(\.coenttb.website.router) var serverRouter
        return Image(source: serverRouter.href(for: .asset(.image("coenttb-halftone.png"))), description: "coenttb avatar")
    }()
}
