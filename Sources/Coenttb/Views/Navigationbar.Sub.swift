//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 07-02-2024.
//

import CoenttbWebHTML
import CoenttbWebModels
import Dependencies
import Foundation
import Languages
import ServerRouter
import ServerTranslations
import URLRouting

extension [(URL, String)] {
    init(_ page: WebsitePage) async throws {
        @Dependency(\.serverRouter) var serverRouter

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
                serverRouter.url(for: .choose_country_region),
                String.choose_country_region.description
            ))

        case .contact, .home, .privacy_statement, .terms_of_use, .general_terms_and_conditions, .newsletter:
            break
        default: break
        }
        self = urls
    }
}