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
            copyrightSection: Licences(),
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
                        : (label: "\(String.subscribe.capitalizingFirstLetter())", href: serverRouter.href(for: .newsletter(.subscribe(.request)))),
                        (label: "RSS", href: serverRouter.href(for: .rssXml))
                    ]
                        .compactMap { $0 }
                )
            ]
        )
    }
}

extension CoenttbFooter {
    struct Licences: HTML {
        
        @Dependency(\.envVars.companyName) var companyName
        private let repository = "https://github.com/coenttb/coenttb-com-server"
        var body: some HTML {
            

            if let companyName {
                let year = Calendar(identifier: .gregorian).component( .year, from: Date.now)
                HTMLMarkdown {"""
                ## License
                
                © \(year)\(" " + companyName), all rights reserved for the paid content of coenttb.com, including text, images, and other media. Unauthorized use, reproduction, or distribution of this content is prohibited without prior written permission by coenttb.
                
                All other content of coenttb.com (such as blog posts, documentation, and media not part of paid content) is licensed under [CC BY-NC-SA 4.0 LICENSE](\(repository)/blob/main/CC%20BY-NC-SA%204.0%20LICENSE.md).
                
                The [source code](\(repository)) of this website, excluding all content, is licensed under the [GNU Affero General Public License v3.0 (AGPL-3.0)](\(repository)/blob/main/LICENSE.md).
                
                For organizations or individuals wishing to use content or source code outside the AGPL-3.0 terms, such as in proprietary software or closed-source systems, a commercial license is available. Please contact info@coenttb.com for inquiries.
                """}
                .color(.secondary)
                .fontStyle(.body(.small))
                .padding(top: 2.rem, media: .mobile)
                .linkColor(.coenttbPrimaryColor)
                
            }
            
        }
    }
}



