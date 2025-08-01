//
//  File.swift
//  newsletter3
//
//  Created by Coen ten Thije Boonkkamp on 04/10/2024.
//

import Coenttb_Web
import Mailgun
import Messages

extension Email {
    package static func newsletter3(
    ) -> some HTML {

        @Dependency(\.coenttb.website.router) var router
        let index = 3
        let title = "#\(index) A Tour of PointFreeHTML"

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
                                        src: .init(router.url(for: .public(.asset(.image("coenttb-20250324.png")))).absoluteString),
                                        alt: "coenttb image"
                                    )
                                    .inlineStyle("filter", "sepia(1) hue-rotate(225deg) saturate(5) brightness(1.2)")
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
                            Let’s take a tour through pointfree-html‘s API for generating HTML documents. We will discover how its HTML protocol composes HTML components using recursive rendering and appreciate its handling of attributes and styles—all while delivering blazing-fast performance.

                            This library has made working with HTML much more pleasant for me, both for web content and everyday legal documents. I’m confident you’ll agree with me.
                            """}

                            Link(href: .init(router.url(for: .blog(.post(id: index))).absoluteString)) {
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

                            Header(4) {
                                "Personal note"
                            }
                            EmailMarkdown {"""
                            I'm thrilled to begin sharing my work with a wider audience. While this journey starts modestly with a tour of PointFreeHTML, my goal is to soon showcase powerful Swift technologies designed to advance new legal tech solutions. I genuinely envision those tools will significantly increase the total legal output globally, resulting in more and better justice for all.
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
