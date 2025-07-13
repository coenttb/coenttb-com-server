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
    public static func newsletter3(
    ) -> some HTML {
        
        @Dependency(\.coenttb.website.router) var router
        let index = 4
        let title = "#\(index) Modern Swift Library Architecture: The Swift Package"
        
        
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
                                src: .init(serverRouter.url(for: .public(.asset(.image("coenttb-20250710.png")))).absoluteString),
                                alt: "coenttb image"
                            )
                                .objectPosition(.twoValues(.percentage(50), .percentage(50)))
                        }
                        .margin(.auto)
                        .padding(top: .large, bottom: .large)
                        
                        VStack(alignment: .leading) {
                            
                            EmailMarkdown {"""
                            What are the best, modern practices for Modern Swift Library Architecture? Learn how to break up your Swift package into modules, reduce its complexity, increase code-reuse, and dramatically simplify maintenance.
                            
                            In today's article '\(title)', we build a Swift Package from scratch. By increasing complexity one step at a time, we'll experience when, how, and why to break apart the monolith through modularization and composition.
                            
                            Let's get started.
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
                            Back in March 2025, I released PointFreeHTML, and immediately realized I could achieve the syntax I wanted through a domain model of HTML and CSS—resulting in a type-safe AND domain-accurate HTML DSL in Swift. The project started as a fork of pointfree-html but evolved into something much more modular and composable as I encountered the limitations of monolithic design. It took waaaay longer than I expected!

                            This project became an exploration of how to architect Swift libraries for maximum modularity and reusability. Instead of building one monolithic package, I created an ecosystem of carefully designed packages that compose together: [swift-html-types](https://github.com/coenttb/swift-html-types) and [swift-css-types](https://github.com/coenttb/swift-css-types) provide standards-compliant Swift APIs, while [swift-html-css-pointfree](https://github.com/coenttb/swift-html-css-pointfree) integrates these domain models with HTML-rendering capabilities. [swift-html](https://github.com/coenttb/swift-html) layers on functionality that completes the developer experience at point of use.
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
