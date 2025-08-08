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
                            description: "Type-safe Swift SDK for Stripe payment processing. Bringing the same production quality approach to payment integration.",
                            features: [
                                ("💳", "100% Stripe API coverage - All endpoints"),
                                ("💉", #"Use everywhere using `@Dependency(\.stripe) var stripe`"#),
                                ("✅", "200+ passing tests - Production proven"),
                                ("🚀", "Swift 6 concurrency - Async/await throughout"),
                                ("🔒", "Type-safe API - Compile-time validation"),
                            ],
                            badges: [
                                ("In Development", "#FF9800"),
                                ("AGPL-3.0 / Commercial", "#2196F3")
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
                    
                    div {
                        ProjectCard(
                            title: "swift-html-to-pdf",
                            description: "Lightning-fast HTML to PDF conversion for iOS and macOS. Handle thousands of documents concurrently with customizable margins.",
                            features: [
                                ("🖨️", "Convert HTML to PDF on iOS and macOS"),
                                ("⚡", "Handle thousands of documents quickly"),
                                ("📐", "Customizable margins and layouts"),
                                ("🖼️", "Easy image embedding in PDFs")
                            ],
                            badges: [
                                ("Swift 6.0", "#FF5722"),
                                ("Popular (⭐ 42)", "#9C27B0"),
                                ("Apache 2.0", "#2196F3")
                            ],
                            githubUrl: "https://github.com/coenttb/swift-html-to-pdf"
                        )
                        
                        ProjectCard(
                            title: "swift-environment-variables",
                            description: "Type-safe environment variable management with support for multiple file formats and environment-aware loading.",
                            features: [
                                ("🔐", "Type-safe environment access"),
                                ("📄", "JSON and .env file support"),
                                ("🔄", "Environment-aware overrides"),
                                ("✅", "Required keys validation"),
                                ("💉", "Dependencies integration ready")
                            ],
                            badges: [
                                ("Swift 6.0", "#FF5722"),
                                ("v0.0.1", "#4CAF50"),
                                ("Apache 2.0", "#2196F3")
                            ],
                            githubUrl: "https://github.com/coenttb/swift-environment-variables"
                        )
                        
                        ProjectCard(
                            title: "swift-authenticating",
                            description: "Type-safe HTTP authentication with URL routing integration. Composable and testable API authentication.",
                            features: [
                                ("🔐", "Type-safe authentication"),
                                ("🔑", "Basic and Bearer auth support"),
                                ("🔄", "URL routing integration"),
                                ("🧪", "Fully testable with mocks"),
                                ("🧩", "Composable architecture")
                            ],
                            badges: [
                                ("Swift 6.0", "#FF5722"),
                                ("v0.1.0", "#4CAF50"),
                                ("Apache 2.0", "#2196F3")
                            ],
                            githubUrl: "https://github.com/coenttb/swift-authenticating"
                        )
                        
                        ProjectCard(
                            title: "swift-translating",
                            description: "Comprehensive internationalization with 180+ languages, intelligent fallbacks, and type-safe translations.",
                            features: [
                                ("🌍", "180+ languages support"),
                                ("🔄", "Intelligent fallback chains"),
                                ("🔒", "Type-safe translation API"),
                                ("📅", "Localized date formatting"),
                                ("📝", "Plural forms support")
                            ],
                            badges: [
                                ("Swift 6.0", "#FF5722"),
                                ("In Development", "#FF9800"),
                                ("Apache 2.0", "#2196F3")
                            ],
                            githubUrl: "https://github.com/coenttb/swift-translating"
                        )
                        
                        ProjectCard(
                            title: "swift-emailaddress",
                            description: "Type-safe email address validation and domain modeling. Never store invalid email addresses again.",
                            features: [
                                ("📧", "RFC-compliant email validation"),
                                ("🔒", "Type-safe email handling"),
                                ("🎯", "Domain model for emails"),
                                ("✅", "Compile-time safety"),
                                ("🧩", "Integrates with swift-authenticating")
                            ],
                            badges: [
                                ("Swift 6.0", "#FF5722"),
                                ("v0.0.1", "#4CAF50"),
                                ("Apache 2.0", "#2196F3")
                            ],
                            githubUrl: "https://github.com/coenttb/swift-emailaddress"
                        )
                        
                        ProjectCard(
                            title: "swift-ratelimiter",
                            description: "Protect your APIs from abuse with configurable rate limiting. Token bucket and sliding window algorithms.",
                            features: [
                                ("🛡️", "Protect against API abuse"),
                                ("⏱️", "Token bucket algorithm"),
                                ("📊", "Sliding window support"),
                                ("🔧", "Configurable limits"),
                                ("💉", "Dependencies integration")
                            ],
                            badges: [
                                ("Swift 6.0", "#FF5722"),
                                ("v0.0.1", "#4CAF50"),
                                ("Apache 2.0", "#2196F3")
                            ],
                            githubUrl: "https://github.com/coenttb/swift-ratelimiter"
                        )
                        
                        ProjectCard(
                            title: "swift-jwt",
                            description: "JSON Web Token handling for secure authentication. Sign, verify, and decode JWTs with ease.",
                            features: [
                                ("🔐", "JWT signing and verification"),
                                ("🔑", "Multiple algorithm support"),
                                ("📝", "Claims validation"),
                                ("⏰", "Expiration handling"),
                                ("🔒", "Type-safe API")
                            ],
                            badges: [
                                ("Swift 6.0", "#FF5722"),
                                ("v0.0.1", "#4CAF50"),
                                ("Apache 2.0", "#2196F3")
                            ],
                            githubUrl: "https://github.com/coenttb/swift-jwt"
                        )
                    }
                    .display(.grid)
                    .inlineStyle("grid-template-columns", "repeat(auto-fit, minmax(20rem, 1fr))")
                    .gap(.rem(2))
                    .alignItems(.stretch)
                    .padding(bottom: .rem(3))
                    
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
                        
                        div {
                            ProjectCard(
                                title: "RFC 7519 - JWT",
                                description: "Pure JWT implementation without cryptographic dependencies. Lightweight, flexible, and universally compatible across all platforms.",
                                features: [
                                    ("📜", "RFC 7519 compliant"),
                                    ("🪶", "Zero dependencies - Pure Swift"),
                                    ("🌐", "Cross-platform compatible"),
                                    ("⚡", "Fast parsing and inspection"),
                                    ("🧪", "Easy to mock for testing")
                                ],
                                badges: [
                                    ("RFC Standard", "#673AB7"),
                                    ("v1.0.0", "#4CAF50"),
                                    ("MIT", "#2196F3")
                                ],
                                githubUrl: "https://github.com/swift-web-standards/swift-rfc-7519"
                            )
                            
                            ProjectCard(
                                title: "RFC 5321 - SMTP",
                                description: "Swift implementation of Simple Mail Transfer Protocol. Essential for email infrastructure and mail server communication.",
                                features: [
                                    ("📧", "SMTP protocol implementation"),
                                    ("📜", "RFC 5321 compliant"),
                                    ("🔧", "Mail server communication"),
                                    ("✉️", "Email infrastructure support"),
                                    ("🔒", "Type-safe protocol handling")
                                ],
                                badges: [
                                    ("RFC Standard", "#673AB7"),
                                    ("Email", "#4CAF50"),
                                    ("MIT", "#2196F3")
                                ],
                                githubUrl: "https://github.com/swift-web-standards/swift-rfc-5321"
                            )
                            
                            ProjectCard(
                                title: "RFC 5322 - Email Format",
                                description: "Internet Message Format standard. Parse and validate email headers, addresses, and message structure.",
                                features: [
                                    ("📨", "Email format validation"),
                                    ("📜", "RFC 5322 compliant"),
                                    ("📅", "Date/time parsing"),
                                    ("🔍", "Header field parsing"),
                                    ("✅", "Message structure validation")
                                ],
                                badges: [
                                    ("RFC Standard", "#673AB7"),
                                    ("Email", "#4CAF50"),
                                    ("MIT", "#2196F3")
                                ],
                                githubUrl: "https://github.com/swift-web-standards/swift-rfc-5322"
                            )
                            
                            ProjectCard(
                                title: "RFC 7617 - Basic Auth",
                                description: "HTTP Basic Authentication Scheme. Secure and standards-compliant authentication for web services.",
                                features: [
                                    ("🔐", "HTTP Basic Authentication"),
                                    ("📜", "RFC 7617 compliant"),
                                    ("🔑", "Credentials encoding/decoding"),
                                    ("🛡️", "Secure authentication"),
                                    ("🌐", "HTTP header handling")
                                ],
                                badges: [
                                    ("RFC Standard", "#673AB7"),
                                    ("Auth", "#FF9800"),
                                    ("MIT", "#2196F3")
                                ],
                                githubUrl: "https://github.com/swift-web-standards/swift-rfc-7617"
                            )
                            
                            ProjectCard(
                                title: "RFC 6750 - Bearer Token",
                                description: "OAuth 2.0 Bearer Token Usage. Essential for modern API authentication and authorization.",
                                features: [
                                    ("🎫", "Bearer token handling"),
                                    ("📜", "RFC 6750 compliant"),
                                    ("🔒", "OAuth 2.0 support"),
                                    ("🌐", "API authentication"),
                                    ("🛡️", "Authorization header parsing")
                                ],
                                badges: [
                                    ("RFC Standard", "#673AB7"),
                                    ("OAuth", "#FF9800"),
                                    ("MIT", "#2196F3")
                                ],
                                githubUrl: "https://github.com/swift-web-standards/swift-rfc-6750"
                            )
                            
                            ProjectCard(
                                title: "More RFC Standards",
                                description: "Additional RFC implementations including DNS (1035), Internet Host Requirements (1123), Email Date Formats (2822), and International Email (6531).",
                                features: [
                                    ("🌐", "RFC 1035 - DNS"),
                                    ("🖥️", "RFC 1123 - Internet Hosts"),
                                    ("📅", "RFC 2822 - Email Date Format"),
                                    ("🌍", "RFC 6531 - International Email"),
                                    ("📚", "Growing collection of standards")
                                ],
                                badges: [
                                    ("RFC Standards", "#673AB7"),
                                    ("Collection", "#9C27B0"),
                                    ("MIT", "#2196F3")
                                ],
                                githubUrl: "https://github.com/swift-web-standards"
                            )
                        }
                        .display(.grid)
                        .inlineStyle("grid-template-columns", "repeat(auto-fit, minmax(20rem, 1fr))")
                        .gap(.rem(2))
                        .alignItems(.stretch)
                        .padding(bottom: .rem(3))
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
    let features: [(icon: String, text: String)]
    let badges: [(String, String)]
    let githubUrl: String
    let headerImage: String?
    
    init(
        title: String,
        description: String,
        features: [(icon: String, text: String)],
        badges: [(String, String)],
        githubUrl: String,
        headerImage: String? = nil
    ) {
        self.title = title
        self.description = description
        self.features = features
        self.badges = badges
        self.githubUrl = githubUrl
        self.headerImage = headerImage
    }
    
    @Dependency(\.coenttb.website.router) var router
    
    var body: some HTML {
        Card(
            content: {
                CoenttbHTML.Paragraph {
                    description
                }
                .marginBottom(.rem(1))
                .lineHeight(1.6)
                
                if !features.isEmpty {
                    VStack(spacing: .rem(0.66)) {
                        HTMLForEach(features) { feature in
                            Label {
                                HTMLText(feature.icon)
                            } title: {
                                HTMLMarkdown(feature.text)
                            }
                        }
                    }
                    .marginBottom(.rem(0.25))
                }
            },
            header: {
                div {
                    div {
                        Header(3) {
                            HTMLText(title)
                        }
                        .color(.text.primary.reverse())
                        .marginBottom(.rem(1))
                        
                        div {
                            HTMLForEach(badges) { badge in
                                span {
                                    badge.0
                                }
                                .padding(vertical: .rem(0.25), horizontal: .rem(0.5))
                                .backgroundColor(.hex("\(badge.1)"))
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
                        .position(.absolute)
                        .bottom(.rem(1.5))
                        .left(.rem(1.5))
                        .right(headerImage != nil ? .rem(7) : .rem(1.5))
                        
                        if let headerImage = headerImage {
                            Image(
                                src: .init(router.url(for: .public(.asset(.image("\(headerImage)"))))),
                                alt: .init(title)
                            )
                            .height(.rem(4))
                            .width(.auto)
                            .objectFit(.contain)
                            .position(.absolute)
                            .bottom(.rem(1.5))
                            .right(.rem(1.5))
                        }
                    }
                    .backgroundColor(.background.primary.reverse())
                    .padding(.rem(1.5))
                    .minHeight(.rem(10))
                    .width(.percent(100))
                    .position(.relative)
                }
                .minHeight(.rem(10))
                .display(.flex)
                .alignItems(.center)
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

