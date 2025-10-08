//
//  File 2.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 24-12-2023.
//

import CasePaths
import Coenttb_Blog
import Coenttb_Newsletter
import Dependencies
import Foundation
import Translating
import URLRouting

extension Route {
    @CasePathable
    @dynamicMemberLookup
    public enum Website: Codable, Hashable, Sendable {
        case blog(Blog.Route.View = .index)
        case newsletter(Newsletter.Route.View)
        case choose_country_region
        case contact
        case home
        case projects
        case privacy_statement
        case terms_of_use
        case general_terms_and_conditions
    }
}

extension Route.Website {
    public struct Router: ParserPrinter, Sendable {

        public init() {}

        public var body: some URLRouting.Router<Route.Website> {
            OneOf {
                URLRouting.Route(.case(Route.Website.blog)) {
                    Path { String.blog.slug() }
                    Blog.Route.View.Router()
                }

                OneOf {
                    // Convenience route FIRST (more specific) - handles /newsletter/subscribe
                    URLRouting.Route(.case(Route.Website.newsletter(.subscribe(.request)))) {
                        Path {
                            String.newsletter.slug()
                            String.subscribe.slug()
                        }
                    }

                    URLRouting.Route(.case(Route.Website.newsletter)) {
                        Path { String.newsletter.slug() }
                        Newsletter.Route.View.Router()
                    }

                }

                URLRouting.Route(.case(Route.Website.choose_country_region)) {
                    Path { String.choose_country_region.slug() }
                }

                URLRouting.Route(.case(Route.Website.contact)) {
                    Path { String.contact.slug() }
                }

                URLRouting.Route(.case(Route.Website.projects)) {
                    Path { "projects" }
                }

                URLRouting.Route(.case(Route.Website.privacy_statement)) {
                    Path { String.privacyStatement.slug() }
                }

                URLRouting.Route(.case(Route.Website.privacy_statement)) {
                    Path { String.privacyPolicy.slug() }
                }

                URLRouting.Route(.case(Route.Website.terms_of_use)) {
                    Path { String.terms_of_use.slug() }
                }

                URLRouting.Route(.case(Route.Website.general_terms_and_conditions)) {
                    Path { String.general_terms_and_conditions.slug() }
                }

                URLRouting.Route(.case(Route.Website.home))
            }
        }
    }
}
