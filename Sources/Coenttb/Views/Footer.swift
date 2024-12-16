//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/08/2024.
//

import CoenttbHTML
import CoenttbMarkdown
import CoenttbWebHTML
import CoenttbWebTranslations
import Dependencies
import Foundation
import ServerRouter

extension HTML {

    @HTMLBuilder
    public func fontStyle2(_ fontStyle: CoenttbHTML.FontStyle) -> some HTML {
        switch fontStyle {
        case .body(.small):
            self
//            self.fontScale(.h6)
//                .font(.weight(.normal))
//                .lineHeight(.number(1.5))

        case .body(.regular):
            self
//            self.fontScale(.h5)
//                .font(.weight(.normal))
//                .lineHeight(.number(1.5))
        }
    }
}

public struct CoenttbFooter: HTML {

    @Dependency(\.serverRouter) var serverRouter
    @Dependency(\.blog.getAll) var blogPosts
    @Dependency(\.envVars) var envVars

    @Dependency(\.currentUser?.newsletterSubscribed) var newsletterSubscribed

    public init() {}

    public var body: some HTML {

        let posts = blogPosts()
        Footer(
            foregroundColor: .primary,
            backgroundColor: .offWhite.withDarkColor(.offBlack),
            tagline: .init(
                title: "coenttb",
                href: serverRouter.href(for: .home),
                content: Paragraph {
                    HTMLText("\(Coenttb.oneliner) \(String.with) ")
                    Link("coenttb", href: "https://x.com/coenttb")
                    "."
                }
            ),
            copyrightHolder: (
                name: "coenttb",
                color: .tertiary
            ),
            columns: [
                (
                    title: "Content",
                    links: [
                        !posts.isEmpty ? (label: .blog.capitalizingFirstLetter().description, href: serverRouter.href(for: .blog(.index))) : nil
                    ].compactMap { $0 }
                ),
                (
                    title: "\(String.more.capitalizingFirstLetter())",
                    links: [
                        envVars.companyXComHandle.map { handle in
                            (label: "X/Twitter", href: "https://www.x.com/\(handle)")
                        },
                        envVars.companyGitHubHandle.map { handle in
                            (label: "Github", href: "https://github.com/\(handle)")
                        },
                        envVars.companyLinkedInHandle.map { handle in
                            (label: "LinkedIn", href: "https://www.linkedin.com/in/\(handle)")
                        },
                        (label: "\(String.contact_me.capitalizingFirstLetter())", href: serverRouter.href(for: .contact)),
                        (label: "\(String.privacyStatement.capitalizingFirstLetter())", href: serverRouter.href(for: .privacy_statement)),
                        (label: "\(String.general_terms_and_conditions.capitalizingFirstLetter())", href: serverRouter.href(for: .general_terms_and_conditions)),
                        (label: "\(String.terms_of_use.capitalizingFirstLetter())", href: serverRouter.href(for: .terms_of_use)),
                        newsletterSubscribed == true
                        ? (label: "\(String.unsubscribe.capitalizingFirstLetter())", href: serverRouter.href(for: .newsletter(.unsubscribe)))
                        : (label: "\(String.subscribe.capitalizingFirstLetter())", href: serverRouter.href(for: .newsletter(.subscribe)))
                    ]
                        .compactMap { $0 }
                )
            ]
        )
    }
}
