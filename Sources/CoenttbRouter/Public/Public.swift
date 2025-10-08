//
//  File 2.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 24-12-2023.
//

import CasePaths
import Dependencies
import Foundation
import Translating
import URLRouting

extension Route {
    public enum Public: Equatable, Sendable {
        case asset(Public.Asset)
        case wellKnown(Route.Public.WellKnown)
        case robots
        case sitemap
        case rssXml
        case favicon(Route.Public.Asset.Favicon)
    }
}

extension Route.Public {
    public struct Router: ParserPrinter, Sendable {

        public static let shared: Self = .init()

        public var body: some URLRouting.Router<Route.Public> {
            OneOf {
                URLRouting.Route(.case(Route.Public.asset)) {
                    Path.assets
                    Route.Public.Asset.Router()
                }
                URLRouting.Route(.case(Route.Public.rssXml)) {
                    Path.rssXml
                }
                URLRouting.Route(.case(Route.Public.wellKnown)) {
                    Path.well_known
                    Route.Public.WellKnown.Router()
                }
                URLRouting.Route(.case(Route.Public.robots)) {
                    Path.robotsTxt
                }
                URLRouting.Route(.case(Route.Public.sitemap)) {
                    Path.sitemapXml
                }

                URLRouting.Route(.case(Route.Public.favicon)) {
                    Route.Public.Asset.Favicon.Router()
                }
            }
        }
    }
}
