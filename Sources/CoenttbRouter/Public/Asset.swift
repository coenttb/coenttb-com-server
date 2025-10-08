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
import URLRouting

extension Route.Public {
    public enum Asset: Equatable, Sendable {
        case favicon(Route.Public.Asset.Favicon)
        case image(Route.Public.Asset.Image)
        case logo(Route.Public.Asset.Logo)
    }
}

extension Route.Public.Asset {
    public struct Router: ParserPrinter, Sendable {
        public var body: some URLRouting.Router<Route.Public.Asset> {
            OneOf {
                URLRouting.Route(.case(Route.Public.Asset.favicon)) {
                    Path.favicon
                    Route.Public.Asset.Favicon.Router()
                }

                URLRouting.Route(.case(Route.Public.Asset.image)) {
                    Path.image
                    Route.Public.Asset.Image.Router()
                }

                URLRouting.Route(.case(Route.Public.Asset.logo)) {
                    Path.logo
                    Route.Public.Asset.Logo.Router()
                }
            }
        }
    }
}

extension Route.Public.Asset {
    public enum Logo: String, Codable, Hashable, Sendable {
        case svg = "logo.svg"
        case white = "logo_light.svg"
        case muted = "logo_dark.svg"
        case favicon_light = "favicon_light.png"
        case favicon_dark = "favicon_dark.png"
    }
}

extension Route.Public.Asset.Logo {
    public struct Router: ParserPrinter {
        public var body: some URLRouting.Router<Route.Public.Asset.Logo> {
            OneOf {

                URLRouting.Route(.case(Route.Public.Asset.Logo.favicon_light)) {
                    Path { Route.Public.Asset.Logo.favicon_light.rawValue }
                }

                URLRouting.Route(.case(Route.Public.Asset.Logo.favicon_dark)) {
                    Path { Route.Public.Asset.Logo.favicon_dark.rawValue }
                }

                URLRouting.Route(.case(Route.Public.Asset.Logo.svg)) {
                    Path { Route.Public.Asset.Logo.svg.rawValue }
                }

                URLRouting.Route(.case(Route.Public.Asset.Logo.white)) {
                    Path { Route.Public.Asset.Logo.white.rawValue }
                }

                URLRouting.Route(.case(Route.Public.Asset.Logo.muted)) {
                    Path { Route.Public.Asset.Logo.muted.rawValue }
                }
            }
        }
    }
}

extension Route.Public.Asset {
    public struct Image: Codable, Hashable, RawRepresentable, ExpressibleByStringLiteral, ExpressibleByStringInterpolation, Sendable {

        public let rawValue: String

        public init(rawValue value: String) {
            self.rawValue = value
        }

        public init(stringLiteral value: String) {
            self.rawValue = value
        }
    }
}

extension Route.Public.Asset.Image {
    public struct Router: ParserPrinter {
        public var body: some URLRouting.Router<Route.Public.Asset.Image> {

            Path { Parse(.string.representing(Route.Public.Asset.Image.self)) }
        }
    }
}
