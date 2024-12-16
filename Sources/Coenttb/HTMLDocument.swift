//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/08/2024.
//

import CoenttbWebHTML
import Dependencies
import EnvVars
import Favicon
import Foundation
import Languages
import ServerRouter
import Vapor
import Hotjar
import GoogleAnalytics

public struct DefaultHTMLDocument<
    Styles: HTML,
    Scripts: HTML,
    Body: HTML,
    SideBar: HTML,
    NavigationBar: HTML,
    Footer: HTML
>: HTMLDocument {
    let themeColor: HTMLColor
    let languages: [Languages.Language]
    let styles: Styles
    let scripts: Scripts
    let favicons: Favicons
    let _sideBar: SideBar
    let _navigationBar: NavigationBar
    let _body: Body
    let _footer: Footer

    public init(
        themeColor: HTMLColor = .coenttbAccentColor,
        languages: [Languages.Language] = Languages.Language.allCases,
        @HTMLBuilder styles: () -> Styles = { HTMLEmpty() },
        @HTMLBuilder scripts: () -> Scripts = {
            HTMLGroup {
                PrismJSHead(
                    languages: ["swift"]
                )
                fontAwesomeScript
            }
        },
        @HTMLBuilder favicons: () -> Favicons = { Favicons.coenttb },
        @HTMLBuilder sideBar: () -> SideBar = { HTMLEmpty() },
        @HTMLBuilder navigationBar: () -> NavigationBar = { CoenttbNavigationBar() },
        @HTMLBuilder body: () -> Body,
        @HTMLBuilder footer: () -> Footer = {
            CoenttbFooter()
                .gradient(bottom: .coenttbAccentColor, middle: .white.withDarkColor(.black), top: .white.withDarkColor(.black))
                .linkColor(.primary)
        }
    ) {
        self.themeColor = themeColor
        self.languages = languages
        self.styles = styles()
        self.scripts = scripts()
        self.favicons = favicons()
        self._sideBar = sideBar()
        self._navigationBar = navigationBar()
        self._body = body()
        self._footer = footer()
    }

    public var head: some HTML {
        CoenttbHTMLDocumentHeader(
            themeColor: themeColor,
            languages: languages,
            styles: { styles },
            scripts: { scripts },
            favicons: { favicons }
        )!
    }

    @Dependency(\.language) var language

    public var body: some HTML {
        HTMLGroup {

            _navigationBar
                .backgroundColor(themeColor)

            _body

            _footer

        }
        .dependency(\.language, language)
        .linkColor(.coenttbPrimaryColor)
    }
}

extension DefaultHTMLDocument: AsyncResponseEncodable {}

public struct CoenttbHTMLDocumentHeader<
    Styles: HTML,
    Scripts: HTML
>: HTML {
    public init?(
        themeColor: HTMLColor = .coenttbAccentColor,
        languages: [Languages.Language] = Languages.Language.allCases,
        @HTMLBuilder styles: () -> Styles = { HTMLEmpty() },
        @HTMLBuilder scripts: () -> Scripts = { HTMLEmpty() },
        @HTMLBuilder favicons: () -> Favicons = { Favicons.coenttb }
    ) {

        @Dependency(\.serverRouter) var siteRouter
        @Dependency(\.language) var language
        @Dependency(\.route.website?.page) var page
        @Dependency(\.envVars.hotjarAnalytics?.id) var hotjarAnalyticsId
        @Dependency(\.envVars.googleAnalytics?.id) var googleAnalyticsId
        @Dependency(\.envVars.canonicalHost) var canonicalHost

        guard let page
        else { return nil }

        let title: String = switch page.title?.capitalizingFirstLetter() {
        case nil:
            canonicalHost ?? ""
        case let .some(description):
            canonicalHost.map { "\(description) - \($0)" } ?? "\(description)"
        }

        let canonicalHref = URL(string: "\(canonicalHost ?? "localhost:8080")\(siteRouter.href(for: page))")!
        let description = page.description()?.description
        let hreflang = { siteRouter.url(for: .init(language: $0, page: page)) }

        let scripts = HTMLGroup {
            FontAwesomeScript()

            PrismJSHead(languages: ["swift"])

            scripts()

            if let googleAnalyticsId {
                GoogleAnalyticsHead(id: googleAnalyticsId)
            }

            if let hotjarAnalyticsId {
                HotjarHead(
                    id: hotjarAnalyticsId,
                    website: canonicalHref
                )
            }
        }

        self.body = CoenttbWebHTMLDocumentHeader(
            title: title,
            description: description,
            canonicalHref: canonicalHref,
            themeColor: themeColor,
            language: language,
            languages: languages,
            hreflang: hreflang,
            styles: styles,
            scripts: {
                scripts
            },
            favicons: favicons
        )
    }

    public let body: CoenttbWebHTMLDocumentHeader<
        Styles,
        HTMLGroup<_HTMLTuple<FontAwesomeScript, PrismJSHead, Scripts, GoogleAnalyticsHead?, HotjarHead?>>
    >
}
