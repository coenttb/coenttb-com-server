//
//  WebsitePage.projects.swift
//  coenttb-com-server
//
//  Created on 2025-08-08.
//

import CoenttbRouter
import CoenttbShared
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
                    
                    Cards(columns: .two) {
                        [ProjectCard].featured
                    }
                        .padding(bottom: .rem(3))
                    
                    Header(2) {
                        "In Development"
                    }
                    .textAlign(.center)
                    .padding(bottom: .rem(2))
                    
                    div {
                        ProjectCard.coenttbStripe
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
                    
                    Cards { for card in [ProjectCard].infrastructure { card } }
                    
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
                        
                        Cards { for card in [ProjectCard].swiftWebStandards { card } }
                        
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

extension [ProjectCard] {
    
    static var infrastructure: Self {
        Array {
            ProjectCard.swiftHtmlTopdf
            
            ProjectCard.swiftEnvironmentVariables
            
            ProjectCard.swiftAuthenticating
            
            ProjectCard.swiftTranslating
            
            ProjectCard.swiftEmailaddress
            
            ProjectCard.swiftRatelimiter
            
            ProjectCard.swiftJwt
        }
    }
    
    static var swiftWebStandards: Self {
        Array {
            ProjectCard.rfc7519Jwt
            
            ProjectCard.rfc5321Smtp
            
            ProjectCard.rfc5322EmailFormat
            
            ProjectCard.rfc7617BasicAuth
            
            ProjectCard.rfc6750BearerToken
            
            ProjectCard.moreRfcStandards
        }
    }
    
    static var featured: Self {
        Array {
            ProjectCard.boiler
            ProjectCard.swiftHtml
            ProjectCard.coenttbMailgun
            ProjectCard.coenttbComServer
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
                    .paddingTop(.rem(1))
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
                                .height(.rem(4))
                                .width(.auto)
                                .objectFit(.contain)
                                .position(.absolute)
                                .bottom(.rem(1.5))
                                .right(.rem(1.5))
                                .display(Display.none, media: .mobile)
                                .display(.block, media: .tablet)
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


extension ProjectCard {
    static var swiftHtmlTopdf: Self {
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
    }
    
    static var coenttbStripe: Self {
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
    
    static var swiftEnvironmentVariables: Self {
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
    }
    
    static var swiftAuthenticating: Self {
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
    }
    
    static var swiftTranslating: Self {
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
    }
    
    static var swiftEmailaddress: Self {
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
    }
    
    static var swiftRatelimiter: Self {
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
    }
    
    static var swiftJwt: Self {
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
    
    static var rfc7519Jwt: Self {
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
    }
    
    static var rfc5321Smtp: Self {
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
    }
    
    static var rfc5322EmailFormat: Self {
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
    }
    
    static var rfc7617BasicAuth: Self {
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
    }
    
    static var rfc6750BearerToken: Self {
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
    }
    
    static var moreRfcStandards: Self {
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
    
    static var boiler: Self {
        @Dependency(\.coenttb.website.router) var router
        return ProjectCard(
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
            headerImage: Image(
                src: .init(router.url(for: .public(.asset(.image("boiler-badge.png"))))),
                alt: "boiler-badge"
            )
        )
    }
    
    static var swiftHtml: Self {
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
    }
    
    static var coenttbMailgun: Self {
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
    }
    
    static var coenttbComServer: Self {
        @Dependency(\.coenttb.website.router) var router
        return ProjectCard(
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
