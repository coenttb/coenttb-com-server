//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 08/08/2025.
//

import Coenttb_Com_Router
import Coenttb_Com_Shared
import Coenttb_Vapor
import Coenttb_Web_HTML
import Dependencies
import Foundation
import Server_EnvVars
import Server_Integration

public struct FeaturedPackages: HTML {
    
    public init() {}
    
    @Dependency(\.coenttb.website.router) var router
    
    public var body: some HTML {
        Cards(columns: .two) {
            ProjectCard(
                title: "Boiler",
                description: #"""
                The Swift server framework that gets you from **idea to production** in record time. Start with zero configuration, then scale seamlessly to production complexity.
                
                Built on **Vapor** (used by Apple) with **type-safe HTML, routing, and dependencies** throughout. Its modular architecture lets you compose exactly what you need, when you need it.
                
                ```swift
                import Boiler

                @main
                struct Server {
                    static func main() async throws {
                        try await Boiler.execute {
                            HTMLDocument {
                                h1 { "Hello, World!" }
                                    .color(.accent)
                            }
                        }
                    }
                }
                ```
                """#,
                badges: [
                    ("Swift 6.0", .swift6),
                    ("Alpha v0.1.0", .version),
                    ("AGPL-3.0 / Commercial", .dualLicense)
                ],
                githubUrl: "https://github.com/coenttb/boiler",
//                headerImage: "boiler-badge.png"
                headerImage: Image(
                    src: .init(router.url(for: .public(.asset(.image("boiler-badge.png"))))),
                    alt: "boiler-badge"
                )
            )
            
            ProjectCard(
                title: "swift-html",
                description: #"""
                Write HTML & CSS with the **power and safety of Swift**. Catch errors at compile-time, not runtime.
                
                Features **SwiftUI-like syntax** that feels native to Swift developers, with **dark mode built-in** and **zero runtime overhead**. All validation happens at compile time, and it renders efficiently as bytes or String.
                
                ```swift
                import HTML
                
                let page = HTMLDocument {
                    h1 { "Type-safe HTML" }
                        .color(.primary)
                    
                    div {
                        p { "Compile-time validation" }
                            .fontSize(.rem(1.2))
                    }
                    .backgroundColor(
                        light: .blue150, 
                        dark: .blue900
                    )
                }
                ```
                """#,
                badges: [
                    ("Swift 6.0", .swift6),
                    ("v0.0.1", .version),
                    ("Apache 2.0", .apacheLicense)
                ],
                githubUrl: "https://github.com/coenttb/swift-html"
            )
            
            ProjectCard(
                title: "coenttb-mailgun",
                description: #"""
                Professional Swift SDK with **100% Mailgun API coverage**. Battle-tested with **200+ tests** in production environments.
                
                Built with modern **Swift 6 concurrency** (async/await throughout), **type-safe** from end to end, and includes **dependency injection** for easy testing.
                
                ```swift
                import Mailgun
                
                @Dependency(\.mailgun.client) var mailgun
                
                let response = try await mailgun.messages.send(
                    .init(
                        from: try .init("hello@yourdomain.com"),
                        to: [try .init("user@example.com")],
                        subject: "Welcome to our service!"
                    ) {
                        h1 { "Welcome aboard!" }
                    }
                )
                ```
                """#,
                badges: [
                    ("Swift 6.0", .swift6),
                    ("Production Ready", .productionReady),
                    ("AGPL-3.0 / Commercial", .dualLicense)
                ],
                githubUrl: "https://github.com/coenttb/coenttb-mailgun"
            )
            
            ProjectCard(
                title: "coenttb-com-server",
                description: #"""
                The production source code for coenttb.com, showcasing real-world usage of the **Boiler framework** and **swift-html DSL** in a live production environment serving thousands of users daily.
                
                This repository demonstrates best practices for building modern Swift server applications with features including type-safe routing, **PostgreSQL database integration** with migrations, user authentication (coming soon) and session management (coming soon), transactional email via **Mailgun**, and RSS/Atom syndication feeds.
                
                Built with a modular architecture that separates concerns into reusable packages, making it an excellent reference for developers looking to understand how to structure and deploy **production-grade Swift web applications**. The codebase includes comprehensive environment-based configuration, Docker deployment support, and Heroku compatibility out of the box.
                """#,
                badges: [
                    ("Swift 6.0", .swift6),
                    ("Production Ready", .productionReady),
                    ("AGPL-3.0 / Commercial", .dualLicense)
                ],
                githubUrl: "https://github.com/coenttb/coenttb-com-server",
                headerImage: Circle(width: .rem(4), height: .rem(4)) {
                    Image(
                        src: .init(router.url(for: .public(.asset(.image("coenttb-halftone.png"))))),
                        alt: "coenttb-logo"
                    )
                }
            )
        }
    }
}



