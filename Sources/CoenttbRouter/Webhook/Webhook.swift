//
//  File 2.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 24-12-2023.
//

import CasePaths
import Dependencies
import Either
import Foundation
import Prelude
import Translating
import URLRouting

extension Route {
    public enum Webhook: Equatable, Sendable {
        case mailgun
    //    case stripe
    }
}

extension Route.Webhook {
    public struct Router: ParserPrinter, Sendable {
        public var body: some URLRouting.Router<Route.Webhook> {
            OneOf {
                URLRouting.Route(.case(Route.Webhook.mailgun)) {
                    Method.post
                    Path { "mailgun" }
                }

//                URLRouting.Route(.case(Route.Webhook.stripe)) {
//                    Method.post
//                    Path { "stripe" }
//                }
            }
        }
    }
}
