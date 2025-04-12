//
//  File.swift
//  coenttb-identities
//
//  Created by Coen ten Thije Boonkkamp on 04/10/2024.
//

import Coenttb_Web
import Identities
import Mailgun
import Messages

extension Email {
    public static func newsletter1(
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
                                    Image.init(
//                                        base64EncodedFromURL: serverRouter.url(for: .public(.asset(.image("coenttb-20250320.png")))),
                                        source: serverRouter.url(for: .public(.asset(.image("coenttb-20250320.png")))).absoluteString,
                                        description: "coenttb image"
                                    )
                                    .inlineStyle("filter", "sepia(1) hue-rotate(-25deg) saturate(5) brightness(1.2)")
                                }
                                .position(.absolute, top: 0, right: 0, bottom: 0, left: 0)
                            }
                            .clipPath(.circle(50.percent))
                            .position(.relative)
                            .size(10.rem)
                        }
                        .margin(CSS.Length.auto)
                        .padding(top: .large, bottom: .large)
                        
                        VStack(alignment: .leading) {
                            
                            EmailMarkdown {"""
                            As a lawyer, I've written countless legal documents. But as my coding skills grew, I became increasingly frustrated that I couldn't easily apply these programming skills to my daily legal work, especially for document creation. Of all the approaches I've explored for generating (legal) documents, I prefer the `pointfree-html` Swift library the most, as it makes it genuinely enjoyable to build and maintain documents.
                            
                            In today's blog we reflect on my journey creating documents in Swift for the web and the office, and we will solve some pesky (legal) formatting issues once and for all.
                            """}
                            
                            Button(
                                tag: a,
                                background: .branding.primary
                            ) {
                                "Click here to read post \(title)"
                            }
                            .color(.text.primary.reverse())
                            .href(router.url(for: .blog(.post(id: index))).absoluteString)
                            .padding(bottom: Length.medium)
                            
                            EmailMarkdown {"""
                            Visit the open-source [GitHub repository](https://github.com/coenttb/pointfree-html), star the project, submit feedback, or even contribute directly—I’d love your input to make this tool even better. 
                            """}
                            
                            Paragraph {
                                "You are receiving this email because you have subscribed to this newsletter. If you no longer wish to receive emails like this, you can unsubscribe "
                                Link("here", href: "%mailing_list_unsubscribe_url%")
                                "."
                            }
                            .linkColor(.text.secondary)
                            .color(.text.secondary)
                            .fontSize(.footnote)
                            
                        }
                        
                    }
                    .padding(vertical: .small, horizontal: .medium)
                }
            }
        }
    }
}
