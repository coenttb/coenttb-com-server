//
//  File 2.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 24-12-2023.
//

import CasePaths
import CoenttbWebStripe
import Dependencies
import Either
import Foundation
import Languages
import Prelude
import URLRouting

public enum Webhook: Equatable, Sendable {
    case mailgun
    case stripe
}

extension Webhook {
    public struct Router: ParserPrinter, Sendable {

        public static let shared: Self = .init()

        public var body: some URLRouting.Router<Webhook> {
            OneOf {
                URLRouting.Route(.case(Webhook.mailgun)) {
                    Method.post
                    Path { "mailgun" }
                }

                URLRouting.Route(.case(Webhook.stripe)) {
                    Method.post
                    Path { "stripe" }
                }
            }
        }
    }
}
