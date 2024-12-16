//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 18-01-2024.
//

import Coenttb
import CoenttbWebHTML
import Dependencies
import Foundation
import Languages
import ServerDependencies
import ServerModels
import ServerRouter
import Vapor

extension WebsitePage {
    static func contact(

    ) async throws -> any AsyncResponseEncodable {

        @Dependency(\.language) var translated

        return Coenttb.DefaultHTMLDocument {
            PageModule(theme: .content) {
                HTMLMarkdown {
                    "Reach out to me on [X](https://x.com/coenttb)."
                }
            }
        }
    }
}
