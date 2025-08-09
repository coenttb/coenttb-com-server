//
//  WebsitePage.projects.swift
//  coenttb-com-server
//
//  Created on 2025-08-08.
//

import Coenttb_Com_Router
import Coenttb_Com_Shared
import Coenttb_Vapor
import Coenttb_Web_HTML
import Dependencies
import Foundation
import Server_EnvVars
import Server_Integration

extension HTMLColor {
    static let swift6: Self = .orange500
    static let apacheLicense: Self = .blue
    static let dualLicense: Self = .blue300
    static let mitLicense: Self = .blue
    static let productionReady: Self = .green
    static let version: Self = .green
    static let popular: Self = .green
    static let inDevelopment: Self = .orange300
    static let rfcStandard: Self = .purple700
    static let email: Self = .green
    static let auth: Self = .orange
    static let collection: Self = .purple300
}

extension Coenttb_Com_Router.Route.Website {
    static func projects() async throws -> any AsyncResponseEncodable {
        
        return Server_Integration.HTMLDocument {
            PageHeader(
                title: "Open Source Swift"
            ) {
                HTMLGroup {
                    span { "Production-ready packages for modern Swift server development" }
                }
                .color(.gray300.withDarkColor(.gray800))
            }
            .gradient(bottom: .background.primary, middle: .branding.accent, top: .branding.accent)
            
            PageModule(theme: .content) {
                VStack {
                    Header(2) {
                        "Featured Packages"
                    }
                    .textAlign(.center)
                    .padding(bottom: .rem(2))
                    
                    FeaturedPackages()
                        .padding(bottom: .rem(3))
                    
                    Header(2) {
                        "In Development"
                    }
                    .textAlign(.center)
                    .padding(bottom: .rem(2))
                    
                    div {
                        ProjectCard(
                            title: "coenttb-stripe",
                            description: #"""
                            Type-safe Swift SDK for Stripe payment processing with **100% API coverage**. Production-tested with **200+ tests**, built with modern **Swift 6 concurrency**, and integrates seamlessly via **dependency injection** (`@Dependency(\.stripe)`).
                            """#,
                            badges: [
                                ("In Development", .inDevelopment),
                                ("AGPL-3.0 / Commercial", .dualLicense)
                            ],
                            githubUrl: "https://github.com/coenttb/coenttb-stripe"
                        )
                    }
                    .display(.grid)
                    .inlineStyle("grid-template-columns", "repeat(auto-fit, minmax(20rem, 1fr))")
                    .gap(.rem(2))
                    .alignItems(.stretch)
                    
                    Header(2) {
                        "Infrastructure & Tools"
                    }
                    .textAlign(.center)
                    .padding(top: .rem(3))
                    .padding(bottom: .rem(2))
                    
                    Cards {
                        ProjectCard(
                            title: "swift-html-to-pdf",
                            description: #"""
                            Lightning-fast **HTML to PDF conversion** for iOS and macOS. Handle **thousands of documents concurrently** with customizable margins and layouts. Seamlessly embed images and create professional PDFs from your HTML content.
                            """#,
                            badges: [
                                ("Swift 6.0", .swift6),
                                ("Popular (⭐ 42)", .popular),
                                ("Apache 2.0", .apacheLicense)
                            ],
                            githubUrl: "https://github.com/coenttb/swift-html-to-pdf"
                        )
                        
                        ProjectCard(
                            title: "swift-environment-variables",
                            description: #"""
                            **Type-safe environment variable management** with support for JSON and .env files. Features **environment-aware overrides**, required keys validation, and seamless **Dependencies integration** for clean dependency injection.
                            """#,
                            badges: [
                                ("Swift 6.0", .swift6),
                                ("v0.0.1", .version),
                                ("Apache 2.0", .apacheLicense)
                            ],
                            githubUrl: "https://github.com/coenttb/swift-environment-variables"
                        )
                        
                        ProjectCard(
                            title: "swift-authenticating",
                            description: #"""
                            **Type-safe HTTP authentication** with URL routing integration. Supports both **Basic and Bearer auth**, features a **composable architecture**, and is fully testable with comprehensive mocking support.
                            """#,
                            badges: [
                                ("Swift 6.0", .swift6),
                                ("v0.1.0", .version),
                                ("Apache 2.0", .apacheLicense)
                            ],
                            githubUrl: "https://github.com/coenttb/swift-authenticating"
                        )
                        
                        ProjectCard(
                            title: "swift-translating",
                            description: #"""
                            Comprehensive internationalization with **180+ languages support**. Features **intelligent fallback chains**, type-safe translation API, localized date formatting, and proper **plural forms support** for natural language handling.
                            """#,
                            badges: [
                                ("Swift 6.0", .swift6),
                                ("In Development", .inDevelopment),
                                ("Apache 2.0", .apacheLicense)
                            ],
                            githubUrl: "https://github.com/coenttb/swift-translating"
                        )
                        
                        ProjectCard(
                            title: "swift-emailaddress",
                            description: #"""
                            **Type-safe email address validation** and domain modeling. **RFC-compliant** validation ensures you never store invalid email addresses. Features **compile-time safety** and seamless integration with swift-authenticating.
                            """#,
                            badges: [
                                ("Swift 6.0", .swift6),
                                ("v0.0.1", .version),
                                ("Apache 2.0", .apacheLicense)
                            ],
                            githubUrl: "https://github.com/coenttb/swift-emailaddress"
                        )
                        
                        ProjectCard(
                            title: "swift-ratelimiter",
                            description: #"""
                            Protect your APIs from abuse with **configurable rate limiting**. Implements both **token bucket** and **sliding window algorithms** with flexible limits and seamless **Dependencies integration**.
                            """#,
                            badges: [
                                ("Swift 6.0", .swift6),
                                ("v0.0.1", .version),
                                ("Apache 2.0", .apacheLicense)
                            ],
                            githubUrl: "https://github.com/coenttb/swift-ratelimiter"
                        )
                        
                        ProjectCard(
                            title: "swift-jwt",
                            description: #"""
                            JSON Web Token handling for **secure authentication**. Sign, verify, and decode JWTs with **multiple algorithm support**, claims validation, expiration handling, and a **type-safe API**.
                            """#,
                            badges: [
                                ("Swift 6.0", .swift6),
                                ("v0.0.1", .version),
                                ("Apache 2.0", .apacheLicense)
                            ],
                            githubUrl: "https://github.com/coenttb/swift-jwt"
                        )
                    }
                    
                    Header(2) {
                        "Web Standards (RFC Implementations)"
                    }
                    .textAlign(.center)
                    .padding(top: .rem(3))
                    .padding(bottom: .rem(2))
                    
                    div {
                        CoenttbHTML.Paragraph {
                            HTMLText("The ")
                            Link(href: .init("https://github.com/swift-web-standards")) {
                                "swift-web-standards"
                            }
                            .color(.branding.accent)
                            .fontWeight(.medium)
                            span { " organization provides type-safe Swift implementations of essential Internet RFCs:" }
                        }
                        .textAlign(.center)
                        .marginBottom(.rem(2))
                        
                        Cards {
                            
                            ProjectCard(
                                title: "RFC 7519 - JWT",
                                description: #"""
                                Pure JWT implementation **without cryptographic dependencies**. **RFC 7519 compliant**, lightweight, and universally **cross-platform compatible**. Features fast parsing and inspection with easy mocking for testing.
                                """#,
                                badges: [
                                    ("RFC Standard", .rfcStandard),
                                    ("v1.0.0", .version),
                                    ("MIT", .mitLicense)
                                ],
                                githubUrl: "https://github.com/swift-web-standards/swift-rfc-7519"
                            )
                            
                            ProjectCard(
                                title: "RFC 5321 - SMTP",
                                description: #"""
                                Swift implementation of **Simple Mail Transfer Protocol**. **RFC 5321 compliant** and essential for email infrastructure and mail server communication with **type-safe protocol handling**.
                                """#,
                                badges: [
                                    ("RFC Standard", .rfcStandard),
                                    ("Email", .email),
                                    ("MIT", .mitLicense)
                                ],
                                githubUrl: "https://github.com/swift-web-standards/swift-rfc-5321"
                            )
                            
                            ProjectCard(
                                title: "RFC 5322 - Email Format",
                                description: #"""
                                **Internet Message Format standard** implementation. **RFC 5322 compliant** parsing and validation of email headers, addresses, and message structure. Includes **date/time parsing** and comprehensive header field validation.
                                """#,
                                badges: [
                                    ("RFC Standard", .rfcStandard),
                                    ("Email", .email),
                                    ("MIT", .mitLicense)
                                ],
                                githubUrl: "https://github.com/swift-web-standards/swift-rfc-5322"
                            )
                            
                            ProjectCard(
                                title: "RFC 7617 - Basic Auth",
                                description: #"""
                                **HTTP Basic Authentication Scheme** implementation. **RFC 7617 compliant** with secure credentials encoding/decoding and proper HTTP header handling for **standards-compliant authentication**.
                                """#,
                                badges: [
                                    ("RFC Standard", .rfcStandard),
                                    ("Auth", .auth),
                                    ("MIT", .mitLicense)
                                ],
                                githubUrl: "https://github.com/swift-web-standards/swift-rfc-7617"
                            )
                            
                            ProjectCard(
                                title: "RFC 6750 - Bearer Token",
                                description: #"""
                                **OAuth 2.0 Bearer Token Usage** implementation. **RFC 6750 compliant** and essential for modern API authentication with proper authorization header parsing and **OAuth 2.0 support**.
                                """#,
                                badges: [
                                    ("RFC Standard", .rfcStandard),
                                    ("OAuth", .auth),
                                    ("MIT", .mitLicense)
                                ],
                                githubUrl: "https://github.com/swift-web-standards/swift-rfc-6750"
                            )
                            
                            ProjectCard(
                                title: "More RFC Standards",
                                description: #"""
                                Additional RFC implementations including **DNS (RFC 1035)**, **Internet Host Requirements (RFC 1123)**, **Email Date Formats (RFC 2822)**, and **International Email (RFC 6531)**. A growing collection of essential web standards.
                                """#,
                                badges: [
                                    ("RFC Standards", .rfcStandard),
                                    ("Collection", .collection),
                                    ("MIT", .mitLicense)
                                ],
                                githubUrl: "https://github.com/swift-web-standards"
                            )
                            
                        }
                    }
                    
                    Header(2) {
                        "Supporting Libraries"
                    }
                    .textAlign(.center)
                    .padding(top: .rem(3))
                    .padding(bottom: .rem(2))
                    
                    div {
                        p {
                            "These packages are part of a comprehensive Swift web development ecosystem. Visit the GitHub repositories for more packages including:"
                        }
                        ul {
                            li {
                                Link(href: .init("https://github.com/coenttb/swift-web-foundation")) {
                                    "swift-web-foundation"
                                }
                                span { " - Website foundation utilities" }
                            }
                            li {
                                Link(href: .init("https://github.com/coenttb/swift-server-foundation")) {
                                    "swift-server-foundation"
                                }
                                span { " - Cross-platform server tools" }
                            }
                            li {
                                Link(href: .init("https://github.com/coenttb/swift-server-foundation-vapor")) {
                                    "swift-server-foundation-vapor"
                                }
                                span { " - Vapor integration layer" }
                            }
                            li {
                                Link(href: .init("https://github.com/coenttb/coenttb-blog")) {
                                    "coenttb-blog"
                                }
                                span { " - Blog engine system" }
                            }
                            li {
                                Link(href: .init("https://github.com/coenttb/coenttb-newsletter")) {
                                    "coenttb-newsletter"
                                }
                                span { " - Newsletter management" }
                            }
                        }
                        .padding(left: .rem(2))
                        .lineHeight(1.8)
                    }
                    .padding(top: .rem(1))
                }
            }
        }
    }
}

struct ProjectCard: HTML {
    let title: String
    let description: String
    let badges: [(String, HTMLColor)]
    let githubUrl: String
    let headerImage: (any HTML)?
    
    init(
        title: String,
        description: String,
        badges: [(String, HTMLColor)],
        githubUrl: String,
        headerImage: (any HTML)? = nil
    ) {
        self.title = title
        self.description = description
        self.badges = badges
        self.githubUrl = githubUrl
        self.headerImage = headerImage
    }
    
    init(
        title: String,
        badges: [(String, HTMLColor)],
        githubUrl: String,
        headerImage: (any HTML)? = nil,
        @MarkdownBuilder description: () -> String
    ) {
        self.title = title
        self.description = description()
        self.badges = badges
        self.githubUrl = githubUrl
        self.headerImage = headerImage
    }
    
    @Dependency(\.coenttb.website.router) var router
    
    var body: some HTML {
        Card(
            content: {
                HTMLMarkdown(description)
                    .lineHeight(1.6)
            },
            header: {
                div {
                    div {
                        Header(3) {
                            HTMLText(title)
                        }
                        .color(
                            light: HTMLColor.text.primary.dark,
                            dark: HTMLColor.text.primary.dark
                        )
                        .marginBottom(.rem(1))
                        
                        div {
                            HTMLForEach(badges) { badge in
                                span {
                                    badge.0
                                }
                                .padding(vertical: .rem(0.25), horizontal: .rem(0.5))
                                .backgroundColor(.init(badge.1))
                                .color(.white)
                                .borderRadius(.px(4))
                                .fontSize(.rem(0.75))
                                .fontWeight(.medium)
                                .marginRight(.rem(0.25))
                                .marginBottom(.rem(0.25))
                                .display(.inlineBlock)
                            }
                        }
                        .display(.flex)
                        .flexWrap(.wrap)
                        .gap(.rem(0.25))
                        .marginTop(.rem(0.5))
                        
                        if let headerImage = headerImage {
                            AnyHTML(headerImage)
                            //                            Image(
                            //                                src: .init(router.url(for: .public(.asset(.image("\(headerImage)"))))),
                            //                                alt: .init(title)
                            //                            )
                                .height(.rem(4))
                                .width(.auto)
                                .objectFit(.contain)
                                .position(.absolute)
                                .top(.rem(1.5))
                                .right(.rem(1.5))
                        }
                    }
                    .backgroundColor(
                        .init(
                            light: HTMLColor.background.primary.reverse().light,
                            dark: HTMLColor.branding.accent.dark
                        )
                    )
                    .padding(.rem(1.5))
                    .minHeight(.rem(8))
                    .width(.percent(100))
                    .position(.relative)
                }
                .display(.flex)
                .alignItems(.stretch)
            },
            footer: {
                Link(href: .init(githubUrl)) {
                    "View on GitHub →"
                }
                .linkUnderline(false)
                .color(.branding.accent)
                .fontWeight(.medium)
                .display(.inlineBlock)
                .padding(.rem(0.75))
                //                .backgroundColor(.branding.accent.map { $0.opacity(0.3)})
                //                .backgroundColor(.branding.accent.map { $0.opacity(0.6)}, pseudo: .hover)
                .borderRadius(.px(6))
                .transition(.all(duration: .ms(200)))
            }
        )
        .transition(.all(duration: .ms(200)))
        .transform(.translateY(.px(-2)), pseudo: .hover)
        .inlineStyle("box-shadow", "0 4px 12px rgba(0, 0, 0, 0.1)", pseudo: .hover)
    }
}

public struct Label<Title: HTML, Icon: HTML>: HTML {
    let alignment: VerticalAlign
    let spacing: Length
    let title: Title
    let icon: Icon
    
    public init(
        alignment: VerticalAlign = .middle,
        spacing: Length = 0.25.rem,
        @HTMLBuilder icon: () -> Icon,
        @HTMLBuilder title: () -> Title
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.icon = icon()
        self.title = title()
    }
    
    public var body: some HTML {
        div {
            span {
                icon
                HTMLText(" ")
            }
            .display(.inlineBlock)
            .verticalAlign(alignment)
            .marginRight(.length(spacing))
            
            span { title }
                .display(.inline)
                .verticalAlign(alignment)
        }
        .display(.flex)
        .alignItems(.start)
    }
}

