//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/08/2024.
//

import Coenttb_Server_HTML
import Dependencies
import Server_EnvVars
import Favicon
import Foundation
import GoogleAnalytics
import Hotjar
import Languages
import Coenttb_Com_Shared

package struct DefaultHTMLDocument<
    Styles: HTML,
    Scripts: HTML,
    Body: HTML,
    SideBar: HTML,
    NavigationBar: HTML,
    Footer: HTML
>: HTMLDocument {
    let themeColor: HTMLColor
    let styles: Styles
    let scripts: Scripts
    let favicons: Favicons
    let _sideBar: SideBar
    let _navigationBar: NavigationBar
    let _body: Body
    let _footer: Footer

    package init(
        themeColor: HTMLColor = .coenttbAccentColor,
        @HTMLBuilder styles: () -> Styles = { HTMLEmpty() },
        @HTMLBuilder scripts: () -> Scripts = {
            HTMLGroup {
                PrismJSHead(languages: ["swift"])
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
        self.styles = styles()
        self.scripts = scripts()
        self.favicons = favicons()
        self._sideBar = sideBar()
        self._navigationBar = navigationBar()
        self._body = body()
        self._footer = footer()
    }

    @Dependency(\.languages) var languages
    
    package var head: some HTML {
        CoenttbHTMLDocumentHeader(
            themeColor: themeColor,
            styles: { styles },
            scripts: { scripts },
            favicons: { favicons }
        )
    }

    @Dependency(\.language) var language

    package var body: some HTML {
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

package struct CoenttbHTMLDocumentHeader<
    Styles: HTML,
    Scripts: HTML
>: HTML {
    package init(
        themeColor: HTMLColor = .coenttbAccentColor,
        @HTMLBuilder styles: () -> Styles = { HTMLEmpty() },
        @HTMLBuilder scripts: () -> Scripts = { HTMLEmpty() },
        @HTMLBuilder favicons: () -> Favicons = { Favicons.coenttb }
    ) {

        @Dependency(\.coenttb.website.router) var router
        @Dependency(\.language) var language
        @Dependency(\.envVars.languages) var languages
        @Dependency(\.route?.website?.page) var page
        @Dependency(\.envVars.hotjarAnalytics?.id) var hotjarAnalyticsId
        @Dependency(\.envVars.googleAnalytics?.id) var googleAnalyticsId
        @Dependency(\.envVars.canonicalHost) var canonicalHost
        @Dependency(\.envVars.baseUrl) var baseUrl

        let title: String = switch page?.title?.capitalizingFirstLetter() {
        case nil:
            canonicalHost ?? ""
        case let .some(description):
            canonicalHost.map { "\(description) - \($0)" } ?? "\(description)"
        }

        let canonicalHref: URL = page.map { router.url(for: $0) } ?? baseUrl
        let description = page?.description()?.description
        let hreflang: (Languages.Language) -> URL = { language in
            page.map { page in
                router.url(for: .init(language: language, page: page))
            } ?? baseUrl
        }

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
            rssXml: router.url(for: .public(.rssXml)),
            themeColor: themeColor,
            language: language,
            hreflang: hreflang,
            styles: styles,
            scripts: { scripts },
            favicons: favicons
        )
    }

    package let body: CoenttbWebHTMLDocumentHeader<
        Styles,
        HTMLGroup<_HTMLTuple<FontAwesomeScript, PrismJSHead, Scripts, GoogleAnalyticsHead?, HotjarHead?>>
    >
}
