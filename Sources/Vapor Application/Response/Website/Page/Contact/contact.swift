//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 18-01-2024.
//
import Coenttb_Vapor
import Coenttb
import Server_Dependencies
import Server_Models
import Coenttb_Com_Shared
import Coenttb_Com_Router

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
