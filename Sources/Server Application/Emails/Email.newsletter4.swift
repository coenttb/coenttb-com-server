//
//  Email.newsletter4.swift
//  coenttb-identities
//
//  Created by Coen ten Thije Boonkkamp on [DATE]
//

import Coenttb_Web
import Identities
import Mailgun
import Messages

extension Email {
    package static func newsletter4(
    ) -> some HTML {

        @Dependency(\.coenttb.website.router) var router
        let index = 5
        let title = "#\(index) Modern Swift Library Architecture: Composition of Packages"

        @Dependency(\.coenttb.website.router) var serverRouter

        return TableEmailDocument(
            preheader: title
        ) {
            tr {
                td {
                    VStack(alignment: .center) {
                        Header(3) {
                            "coenttb "
                            title
                        }

                        Circle {
                            Image(
                                src: .init(serverRouter.url(for: .public(.asset(.image("coenttb-20250714.png")))).absoluteString),
                                alt: "coenttb image"
                            )
                                .objectPosition(.twoValues(.percentage(50), .percentage(50)))
                        }
                        .margin(.auto)
                        .padding(top: .large, bottom: .large)

                        VStack(alignment: .leading) {

                            EmailMarkdown {"""
                            When is breaking apart your Swift package into multiple packages worth the complexity? Discover how to build composable package ecosystems that enable independent evolution, flexible integration, and possibilities you never imagined.

                            In today's article '\(title)', we explore moving beyond single-package architecture to create truly modular systems. Learn when multi-target isn't enough, how to design for composition, and the principles that make package ecosystems thrive.

                            Let's keep exploring.
                            """}

                            Link(href: .init(router.url(for: .blog(.post(id: index))).absoluteString)) {
                                "Read the full article →"
                            }
                            .color(.text.primary.reverse())
                            .padding(bottom: .medium)

                            Header(4) {
                                "Personal note"
                            }

                            EmailMarkdown {"""
                            This article captures the exact architectural evolution I experienced while building the swift-html ecosystem. What started as a simple fork became a deep exploration of how packages should compose together.

                            [I invite you to join the discussion on the Swift forums to adopt `swift-html-types` and `swift-css-types` as community packages.](https://forums.swift.org/t/pitch-community-maintained-html-and-css-swift-types).
                            """}

                            CoenttbHTML.Paragraph {
                                "You are receiving this email because you have subscribed to this newsletter. If you no longer wish to receive emails like this, you can unsubscribe "
                                Link("here", href: "%mailing_list_unsubscribe_url%")
                                "."
                            }
                            .linkColor(.text.secondary)
                            .color(.text.secondary)
                            .font(.footnote)
                        }
                    }
                    .padding(vertical: .small, horizontal: .medium)
                }
            }
        }
    }
}
