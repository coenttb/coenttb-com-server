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
                Swift server and website development made simple. A batteries-included approach with sensible defaults that gets you from 15 lines to production.
                ```swift
                import Boiler

                @main
                struct Server {
                    static func main() async throws {
                        let boiler = "Boiler"
                        
                        try await Boiler.execute {
                            HTMLDocument {
                                h1 { "Start cooking with \(boiler)!" }
                                    .color(.red)
                            }
                        }
                    }
                }
                ```
                """#,
                features: [
                    ("🚀", "Start immediately - No complex configuration"),
                    ("📈", "Learn incrementally - Grow from simple to production"),
                    ("🛡️", "Type-safe HTML (`swift-html`), routing, and dependencies"),
                    ("⚡", "Built on Vapor - Used by Apple"),
                    ("🚀", "Swift 6 concurrency - Async/await throughout"),
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
                Your entry point into domain-accurate and type-safe HTML & CSS development in Swift.
                ```swift
                import HTML
                
                let document = HTMLDocument {
                    h1 { "SwiftUI-syntax for HTML" }

                    h2 { "CSS included!" }
                        .color(.blue)
                }
                ```
                """#,
                features: [
                    ("🎨", "Dark mode built-in"),
                    ("📦", "Lightweight - Minimal dependencies"),
                    ("🔄", "Renders efficiently as bytes or String")
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
                Modern Swift SDK bringing the full power of Swift 6's concurrency to email automation. Production-tested with exhaustive API coverage.
                ```swift
                import Mailgun
                
                @Dependency(\.mailgun.client) var mailgun
                
                let response = try await mailgun.messages.send(
                    .init(
                        from: try .init("coen@coenttb.com"),
                        to: [try .init("you@domain.com")],
                        subject: "Modern, type-safe Swift SDK for Mailgun!",
                        html: "<h1>Production-ready</h1><p>Fully tested</p>"
                    )
                )
                ```
                """#,
                features: [
                    ("📋", "100% Mailgun API coverage - All endpoints"),
                    ("✅", "200+ passing tests - Production proven"),
                    ("🚀", "Swift 6 concurrency - Async/await throughout"),
                    ("🔒", "Type-safe API - Compile-time validation")
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

