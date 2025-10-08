//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 25/05/2024.
//

import Foundation
import URLRouting

extension Route.Public.Asset {
    public enum Favicon: String, Codable, Hashable, Sendable {
        case svg = "favicon.svg"
        case png = "favicon.png"
        case apple_touch_icon_png = "apple-touch-icon.png"
        case apple_touch_icon_precomposed_png = "apple-touch-icon-precomposed.png"
        case favicon_32x32_png = "favicon-32x32.png"
        case favicon_16x16_png = "favicon-16x16.png"
        case site_webmanifest = "site.webmanifest"
        case safari_pinned_tab_svg = "safari-pinned-tab.svg"
        case favicon_ico = "favicon.ico"
        case mstile_150x150_png = "mstile-150x150.png"
        case browserconfig_xml = "browserconfig.xml"
        case android_chrome_192x192_png = "android-chrome-192x192.png"
        case android_chrome_512x512_png = "android-chrome-512x512.png"
    }
}

extension Route.Public.Asset.Favicon {
    public struct Router: ParserPrinter {

        public init() {}

        public var body: some URLRouting.Router<Route.Public.Asset.Favicon> {
            OneOf {
                URLRouting.Route(.case(Route.Public.Asset.Favicon.svg)) {
                    Path { Route.Public.Asset.Favicon.svg.rawValue }
                }

                URLRouting.Route(.case(.png)) {
                    Path { Route.Public.Asset.Favicon.png.rawValue }
                }

                URLRouting.Route(.case(Route.Public.Asset.Favicon.apple_touch_icon_png)) {
                    Path { Route.Public.Asset.Favicon.apple_touch_icon_png.rawValue }
                }

                URLRouting.Route(.case(.favicon_32x32_png)) {
                    Path { Route.Public.Asset.Favicon.favicon_32x32_png.rawValue }
                }

                URLRouting.Route(.case(.favicon_16x16_png)) {
                    Path { Route.Public.Asset.Favicon.favicon_16x16_png.rawValue }
                }

                URLRouting.Route(.case(.site_webmanifest)) {
                    Path { Route.Public.Asset.Favicon.site_webmanifest.rawValue }
                }

                URLRouting.Route(.case(.safari_pinned_tab_svg)) {
                    Path { Route.Public.Asset.Favicon.safari_pinned_tab_svg.rawValue }
                }

                URLRouting.Route(.case(.favicon_ico)) {
                    Path { Route.Public.Asset.Favicon.favicon_ico.rawValue }
                }

                URLRouting.Route(.case(.mstile_150x150_png)) {
                    Path { Route.Public.Asset.Favicon.mstile_150x150_png.rawValue }
                }

                URLRouting.Route(.case(.browserconfig_xml)) {
                    Path { Route.Public.Asset.Favicon.browserconfig_xml.rawValue }
                }

                URLRouting.Route(.case(.android_chrome_192x192_png)) {
                    Path { Route.Public.Asset.Favicon.android_chrome_192x192_png.rawValue }
                }

                URLRouting.Route(.case(.android_chrome_512x512_png)) {
                    Path { Route.Public.Asset.Favicon.android_chrome_512x512_png.rawValue }
                }

                URLRouting.Route(.case(.apple_touch_icon_precomposed_png)) {
                    Path { Route.Public.Asset.Favicon.apple_touch_icon_precomposed_png.rawValue }
                }
            }
        }
    }
}
