//
//  File.swift
//  newsletter2
//
//  Created by Coen ten Thije Boonkkamp on 04/10/2024.
//

import Coenttb_Web
import Mailgun
import Messages

extension Email {
    package static func newsletter2(
    ) -> some HTML {

        @Dependency(\.coenttb.website.router) var router
        let index = 2
        let title = "#\(index) A journey building HTML documents in Swift"

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

                        div {
                            div {
                                div {
                                    Image(
//                                        base64EncodedFromURL: serverRouter.url(for: .public(.asset(.image("coenttb-20250320.png")))),
                                        src: .init(serverRouter.url(for: .public(.asset(.image("coenttb-20250320.png")))).absoluteString),
                                        alt: "coenttb image",
                                        loading: .lazy
                                    )
                                    .inlineStyle("filter", "sepia(1) hue-rotate(-25deg) saturate(5) brightness(1.2)")
                                }
                                .position(
                                    .absolute,
                                    top: .zero,
                                    right: .zero,
                                    bottom: .zero,
                                    left: .zero
                                )
                            }
                            .clipPath(.circle(.percent(50)))
                            .position(.relative)
                            .size(.rem(10))
                        }
                        .margin(.auto)
                        .padding(top: .large, bottom: .large)

                        VStack(alignment: .leading) {

                            EmailMarkdown {"""
                            As a lawyer, I've written countless legal documents. But as my coding skills grew, I became increasingly frustrated that I couldn't easily apply these programming skills to my daily legal work, especially for document creation. Of all the approaches I've explored for generating (legal) documents, I prefer the `pointfree-html` Swift library the most, as it makes it genuinely enjoyable to build and maintain documents.

                            In today's blog we reflect on my journey creating documents in Swift for the web and the office, and we will solve some pesky (legal) formatting issues once and for all.
                            """}

                            Link(href: .url(router.url(for: .blog(.post(id: index))))) {
                                "Click here to read post \(title)"
                            }
                            .color(.text.primary.reverse())
                            .padding(bottom: .medium)
//                            Button(
//                                tag: a,
//                                background: .branding.primary
//                            ) {
//                                "Click here to read post \(title)"
//                            }
//                            .color(.text.primary.reverse())
//                            .href(router.url(for: .blog(.post(id: index))).absoluteString)
//                            .padding(bottom: Length.medium)

                            EmailMarkdown {"""
                            Visit the open-source [GitHub repository](https://github.com/coenttb/pointfree-html), star the project, submit feedback, or even contribute directly—I’d love your input to make this tool even better.
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
