//
//  File 2.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 24-12-2023.
//

import CasePaths
import Dependencies
@preconcurrency import Favicon
import Foundation
import Languages
import URLRouting

public enum Public: Equatable, Sendable {
    case asset(Public.Asset)
    case wellKnown(Public.WellKnown)
    case robots
    case sitemap
    case rssXml
    case favicon(FaviconRouter.Route)
}

extension Public {
    public struct Router: ParserPrinter, Sendable {

        public static let shared: Self = .init()

        public var body: some URLRouting.Router<Public> {
            OneOf {
                URLRouting.Route(.case(Public.asset)) {
                    Path.assets
                    Public.Asset.Router()
                }
                URLRouting.Route(.case(Public.rssXml)) {
                    Path.rssXml
                }
                URLRouting.Route(.case(Public.wellKnown)) {
                    Path.well_known
                    Public.WellKnown.Router()
                }
                URLRouting.Route(.case(Public.robots)) {
                    Path.robotsTxt
                }
                URLRouting.Route(.case(Public.sitemap)) {
                    Path.sitemapXml
                }
                URLRouting.Route(.case(Public.favicon)) {
                    FaviconRouter()
                }
            }
        }
    }
}
