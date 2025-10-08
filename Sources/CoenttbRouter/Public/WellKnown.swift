//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 07-01-2024.
//

import CasePaths
import Dependencies
import Foundation
import Translating
@preconcurrency import URLRouting

extension Route.Public {
    public enum WellKnown: Equatable, Sendable {
        case apple_developer_merchantid_domain_association
    }
}

extension Route.Public.WellKnown {
    public struct Router: ParserPrinter, Sendable {
        public var body: some URLRouting.Router<Route.Public.WellKnown> {
            OneOf {
                URLRouting.Route(.case(Route.Public.WellKnown.apple_developer_merchantid_domain_association)) {
                    Path.apple_developer_merchantid_domain_association
                }
            }
        }
    }
}
