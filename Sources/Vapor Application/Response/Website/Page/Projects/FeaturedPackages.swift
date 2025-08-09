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
    
    public var body: some HTML {
        Cards(columns: .two) {
            ProjectCard(
                title: "Boiler",
                description: #"""
                The Swift server framework that gets you from idea to production in record time. Batteries-included with sensible defaults, type-safe throughout, and battle-tested in production.
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
                features: [
                    ("🚀", "Start immediately - No complex configuration"),
                    ("📈", "Learn incrementally - Grow from simple to production"),
                    ("🛡️", "Type-safe HTML, routing, and dependencies"),
                    ("⚡", "Built on Vapor - Used by Apple"),
                    ("🧩", "Modular architecture - Compose what you need"),
                ],
                badges: [
                    ("Swift 6.0", .swift6),
                    ("Alpha v0.1.0", .version),
                    ("AGPL-3.0 / Commercial", .dualLicense)
                ],
                githubUrl: "https://github.com/coenttb/boiler",
                headerImage: "boiler-badge.png"
            )
            
            ProjectCard(
                title: "swift-html",
                description: #"""
                Write HTML & CSS with the power and safety of Swift. Catch errors at compile-time, not runtime. SwiftUI-like syntax makes web development feel native to Swift developers.
                ```swift
                import HTML
                
                let page = HTMLDocument {
                    h1 { "Type-safe HTML" }
                        .color(.primary)
                    
                    div {
                        p { "Compile-time validation" }
                            .fontSize(.rem(1.2))
                    }
                    .backgroundColor(.init(light: .blue150, dark: .blue900))
                }
                ```
                """#,
                features: [
                    ("🛡️", "Type-safe HTML & CSS - Compile-time validation"),
                    ("🎨", "Dark mode built-in - Responsive by default"),
                    ("⚡", "Zero runtime overhead - All validation at compile time"),
                    ("🧩", "SwiftUI-like syntax - Familiar patterns"),
                    ("📦", "Lightweight - Minimal dependencies"),
                    ("🔄", "Flexible rendering - Bytes or String")
                ],
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
                Professional Swift SDK for Mailgun with complete API coverage. Production-proven with 200+ tests, modern async/await throughout, and type-safe from end to end.
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
                features: [
                    ("📋", "100% Mailgun API coverage - Every endpoint"),
                    ("✅", "200+ passing tests - Production proven"),
                    ("🚀", "Swift 6 concurrency - Async/await throughout"),
                    ("🔒", "Type-safe API - Compile-time validation"),
                    ("🧪", "Dependency injection - Easy testing")
                ],
                badges: [
                    ("Swift 6.0", .swift6),
                    ("Production Ready", .productionReady),
                    ("AGPL-3.0 / Commercial", .dualLicense)
                ],
                githubUrl: "https://github.com/coenttb/coenttb-mailgun"
            )
        }
    }
}

