//
//  File 2.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 24-12-2023.
//

import CasePaths
import CoenttbServerRouter
import CoenttbWebBlog
import CoenttbWebNewsletter
import Dependencies
import Foundation
import Languages
import MacroCodableKit
import MemberwiseInit
import ServerTranslations
import URLRouting

public enum WebsitePage: Codable, Hashable, Sendable {
    case blog(CoenttbWebBlog.Route = .index)
    case newsletter(CoenttbWebNewsletter.Route)
    case choose_country_region
    case contact
    case home
    case privacy_statement
    case terms_of_use
    case general_terms_and_conditions
    case account(WebsitePage.Account)
}

extension WebsitePage {
    public struct Router: ParserPrinter, Sendable {

        public static var shared: Self { .init() }

        public init() {}

        public var body: some URLRouting.Router<WebsitePage> {
            OneOf {
                URLRouting.Route(.case(WebsitePage.account)) {
                    Path { String.account.slug() }
                    WebsitePage.Account.Router()
                }

                URLRouting.Route(.case(WebsitePage.blog)) {
                    Path { String.blog.slug() }
                    CoenttbWebBlog.Route.Router()
                }

                URLRouting.Route(.case(WebsitePage.newsletter)) {
                    Path { String.newsletter.slug() }
                    CoenttbWebNewsletter.Route.Router()
                }

                URLRouting.Route(.case(WebsitePage.choose_country_region)) {
                    Path { String.choose_country_region.slug() }
                }

                URLRouting.Route(.case(WebsitePage.contact)) {
                    Path { String.contact.slug() }
                }

                URLRouting.Route(.case(WebsitePage.privacy_statement)) {
                    Path { String.privacyStatement.slug() }
                }

                URLRouting.Route(.case(WebsitePage.privacy_statement)) {
                    Path { String.privacyPolicy.slug() }
                }

                URLRouting.Route(.case(WebsitePage.terms_of_use)) {
                    Path { String.terms_of_use.slug() }
                }

                URLRouting.Route(.case(WebsitePage.general_terms_and_conditions)) {
                    Path { String.general_terms_and_conditions.slug() }
                }

                URLRouting.Route(.case(WebsitePage.home))
            }
        }
    }
}
