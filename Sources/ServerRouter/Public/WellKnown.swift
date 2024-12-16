//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 07-01-2024.
//

import CasePaths
import CoenttbServerRouter
import Dependencies
import Foundation
import Languages
@preconcurrency import URLRouting

extension Public {
    public enum WellKnown: Equatable, Sendable {
        case apple_developer_merchantid_domain_association
    }
}

extension Public.WellKnown {
    public struct Router: ParserPrinter, Sendable {
        public var body: some URLRouting.Router<Public.WellKnown> {
            OneOf {
                URLRouting.Route(.case(Public.WellKnown.apple_developer_merchantid_domain_association)) {
                    Path.apple_developer_merchantid_domain_association
                }
            }
        }
    }
}
