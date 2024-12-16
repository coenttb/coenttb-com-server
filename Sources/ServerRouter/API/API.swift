//
//  File 2.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 18-12-2023.
//

import CasePaths
import CoenttbWebAccount
import CoenttbWebNewsletter
import CoenttbWebStripe
import Dependencies
import EmailAddress
import Foundation
import Languages
import MacroCodableKit
import MemberwiseInit
import URLRouting

public typealias ServerRouterAPI = API
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
        case newsletter(CoenttbWebNewsletter.API)
        case account(CoenttbWebAccount.API)
        //        case stripe(CoenttbWebStripe.API)
    }
}

extension API.Version1 {
    struct Router: ParserPrinter, Sendable {
        var body: some URLRouting.Router<API.Version1> {
            OneOf {
                URLRouting.Route(.case(API.Version1.newsletter)) {
                    Path { "newsletter" }
                    CoenttbWebNewsletter.API.Router()
                }

//                URLRouting.Route(.case(API.Version1.stripe)) {
//                    Path { "stripe" }
//                    CoenttbWebStripe.API.Router()
//                }

                URLRouting.Route(.case(API.Version1.account)) {
                    Path { "account" }
                    CoenttbWebAccount.API.Router()
                }
            }
        }
    }
}
