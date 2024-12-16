//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 07-01-2024.
//

import CasePaths
import Dependencies
@preconcurrency import Favicon
import Foundation
import Languages
import URLRouting

extension Public {
    public enum Asset: Equatable, Sendable {
        case favicon(FaviconRouter.Route)
        case image(Public.Asset.Image)
        case logo(Public.Asset.Logo)
    }
}

extension Public.Asset {
    public struct Router: ParserPrinter, Sendable {
        public var body: some URLRouting.Router<Public.Asset> {
            OneOf {
                URLRouting.Route(.case(Public.Asset.favicon)) {
                    Path.favicon
                    FaviconRouter()
                }

                URLRouting.Route(.case(Public.Asset.image)) {
                    Path.image
                    Public.Asset.Image.Router()
                }

                URLRouting.Route(.case(Public.Asset.logo)) {
                    Path.logo
                    Public.Asset.Logo.Router()
                }
            }
        }
    }
}

extension Public.Asset {
    public enum Logo: String, Codable, Hashable, Sendable {
        case svg = "logo.svg"
        case white = "logo_light.svg"
        case muted = "logo_dark.svg"
        case favicon_light = "favicon_light.png"
        case favicon_dark = "favicon_dark.png"
    }
}

extension Public.Asset.Logo {
    public struct Router: ParserPrinter {
        public var body: some URLRouting.Router<Public.Asset.Logo> {
            OneOf {

                URLRouting.Route(.case(Public.Asset.Logo.favicon_light)) {
                    Path { Public.Asset.Logo.favicon_light.rawValue }
                }

                URLRouting.Route(.case(Public.Asset.Logo.favicon_dark)) {
                    Path { Public.Asset.Logo.favicon_dark.rawValue }
                }

                URLRouting.Route(.case(Public.Asset.Logo.svg)) {
                    Path { Public.Asset.Logo.svg.rawValue }
                }

                URLRouting.Route(.case(Public.Asset.Logo.white)) {
                    Path { Public.Asset.Logo.white.rawValue }
                }

                URLRouting.Route(.case(Public.Asset.Logo.muted)) {
                    Path { Public.Asset.Logo.muted.rawValue }
                }
            }
        }
    }
}

extension Public.Asset {
    public struct Image: Codable, Hashable, RawRepresentable, ExpressibleByStringLiteral, Sendable {

        public let rawValue: String

        public init(rawValue value: String) {
            self.rawValue = value
        }

        public init(stringLiteral value: String) {
            self.rawValue = value
        }
    }
}

extension Public.Asset.Image {
    public struct Router: ParserPrinter {
        public var body: some URLRouting.Router<Public.Asset.Image> {

            Path { Parse(.string.representing(Public.Asset.Image.self)) }
        }
    }
}
