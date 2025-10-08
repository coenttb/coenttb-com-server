//
//  File.swift
//  rule-law-server
//
//  Created by Coen ten Thije Boonkkamp on 08/02/2025.
//

import CasePaths
import Coenttb_Newsletter
import Coenttb_Server
import Coenttb_Syndication
import Foundation

extension Route {
    @CasePathable
    @dynamicMemberLookup
    public enum API: Equatable, Sendable {
        case syndication(Coenttb_Syndication.API)
        case newsletter(Newsletter.Route.API)
    }
}

extension Route.API {
    public struct Router: ParserPrinter & Sendable {

        public init () {}

        public var body: some URLRouting.Router<Route.API> {
            OneOf {
                URLRouting.Route(.case(Route.API.syndication)) {
                    Coenttb_Syndication.API.Router()
                }

                URLRouting.Route(.case(Route.API.newsletter)) {
                    Newsletter.Route.API.Router()
                }
            }
        }
    }
}
