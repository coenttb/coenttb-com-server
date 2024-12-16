//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 01/09/2024.
//

import CoenttbHTML
import Dependencies
import Foundation
import ServerRouter

extension Image {
    nonisolated(unsafe)
    public static let coenttbGreenSuit: Image = {
        @Dependency(\.serverRouter) var serverRouter
        return Image(source: serverRouter.href(for: .asset(.image("coenttb-halftone.png"))), description: "coenttb avatar")
    }()
}
