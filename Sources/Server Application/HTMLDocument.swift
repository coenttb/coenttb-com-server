//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/08/2024.
//

import Coenttb_Com_Shared
import Coenttb_Server_HTML
import Dependencies
import Favicon
import Foundation
import GoogleAnalytics
import Hotjar
import Languages
import Server_EnvVars

package struct HTMLDocument: HTMLDocumentProtocol {
    package let themeColor: HTMLColor
    package let styles: any HTML
    package let scripts: any HTML
    package let navigationBar: any HTML
    package let _body: any HTML
    package let footer: any HTML
    package let favicons: Favicons

    package init(
        themeColor: HTMLColor = .branding.accent,
        @HTMLBuilder styles: () -> any HTML = { HTMLEmpty() },
        @HTMLBuilder scripts: () -> any HTML = {
            HTMLGroup {
                PrismJSHead(languages: ["swift"])
                fontAwesomeScript
            }
        },
        @HTMLBuilder favicons: () -> Favicons = { Favicons.coenttb },
        @HTMLBuilder navigationBar: () -> any HTML = {
            CoenttbNavigationBar()
        },
        @HTMLBuilder body: () -> any HTML,
        @HTMLBuilder footer: () -> any HTML = {
            CoenttbFooter()
                .gradient(bottom: .branding.accent, middle: .background.primary, top: .background.primary)
        }
    ) {
        self.themeColor = themeColor
        self.styles = styles()
        self.scripts = scripts()
        self.favicons = favicons()
        self.navigationBar = navigationBar()
        self._body = body()
        self.footer = footer()
    }

    @Dependency(\.languages) var languages

    package var head: some HTML {
        CoenttbHTMLDocumentHeader(
            themeColor: themeColor,
            styles: { AnyHTML(styles) },
            scripts: { AnyHTML(scripts) },
            favicons: { favicons }
        )
    }

    @Dependency(\.language) var language

    package var body: some HTML {
        HTMLGroup {

            AnyHTML(navigationBar)
                .backgroundColor(themeColor)

            AnyHTML(_body)

            AnyHTML(footer)

        }
        .dependency(\.language, language)
//        .linkColor(.text.link)
    }
}

package struct CoenttbHTMLDocumentHeader<
    Styles: HTML,
    Scripts: HTML
>: HTML {
    package init(
        themeColor: HTMLColor = .branding.accent,
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
