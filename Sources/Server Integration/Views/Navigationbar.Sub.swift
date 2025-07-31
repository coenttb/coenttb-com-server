//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 07-02-2024.
//

import Coenttb_Com_Router
import Coenttb_Com_Shared
import Coenttb_Web_HTML
import Dependencies
import Foundation
import Server_Translations
import Translating
import URLRouting

extension [(URL, String)] {
    init(_ page: Coenttb_Com_Router.Route.Website) async throws {
        @Dependency(\.coenttb.website.router) var router

        var urls: Self = []

        switch page {

        case let .blog(blog):
            switch blog {
            case .index:
                break
            case .post:
                break
            }

        case .choose_country_region:
            urls.append((
                router.url(for: .page(.choose_country_region)),
                String.choose_country_region.description
            ))

        case .contact, .home, .privacy_statement, .terms_of_use, .general_terms_and_conditions, .newsletter:
            break
        }
        self = urls
    }
}
