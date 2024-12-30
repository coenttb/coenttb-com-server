//
//  File 2.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 18-12-2023.
//

import Coenttb_Web
import Coenttb_Identity
import Coenttb_Newsletter
import Coenttb_Stripe
import Coenttb_Syndication

public typealias Server_RouterAPI = API
public enum API: Equatable, Sendable {
    case v1(Version1)
}

extension API {
    public struct Router: ParserPrinter, Sendable {

        public static let shared: Self = .init()

        public var body: some URLRouting.Router<API> {
            OneOf {
                URLRouting.Route(.case(API.v1)) {
                    Path { "v1" }
                    API.Version1.Router()
                }
            }
        }
    }
}

extension API {
    public enum Version1: Equatable, Sendable {
        case newsletter(Coenttb_Newsletter.API)
        case account(Coenttb_Identity.API)
        case rss(Coenttb_Syndication.API)
    }
}

extension API.Version1 {
    struct Router: ParserPrinter, Sendable {
        var body: some URLRouting.Router<API.Version1> {
            OneOf {
                URLRouting.Route(.case(API.Version1.newsletter)) {
                    Path { "newsletter" }
                    Coenttb_Newsletter.API.Router()
                }

//                URLRouting.Route(.case(API.Version1.stripe)) {
//                    Path { "stripe" }
//                    Coenttb_Stripe.API.Router()
//                }

                URLRouting.Route(.case(API.Version1.account)) {
                    Path { "account" }
                    Coenttb_Identity.API.Router()
                }

                URLRouting.Route(.case(API.Version1.rss)) {
                    Path { "rss" }
                    Coenttb_Syndication.API.Router()
                }
            }
        }
    }
}
