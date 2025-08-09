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
                """#,
                features: [
                    ("🚀", "Start immediately - No complex configuration"),
                    ("📈", "Learn incrementally - Grow from simple to production"),
                    ("🛡️", "Type-safe HTML (`swift-html`), routing, and dependencies"),
                    ("⚡", "Built on Vapor - Used by Apple"),
                    ("🧩", "Encourages modular server architecture")
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
                description: "Your entry point into comprehensive type-safe web development in Swift. Catch HTML and CSS errors at compile time, not runtime.",
                features: [
                    ("🛡️", "Type-safe and domain-accurate HTML & CSS - Compile-time validation"),
                    ("🧩", "SwiftUI-like syntax - Familiar patterns"),
                    ("🎨", "Dark mode built-in"),
                    ("⚡", "Zero runtime overhead - All validation at compile time"),
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
                @Dependency(\.mailgun.client) var mailgun
                let response = try await mailgun.messages.send(
                    .init(
                        from: try .init("hello@yourdomain.com"),
                        to: [try .init("user@example.com")],
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

