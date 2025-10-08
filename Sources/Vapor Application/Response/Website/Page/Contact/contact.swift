//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 18-01-2024.
//
import CoenttbRouter
import CoenttbShared
import ServerFoundationVapor
import Coenttb_Web_HTML
import HTMLTypesFoundation
import Server_Dependencies
import Server_Integration
import Server_Models

extension Coenttb_Com_Router.Route.Website {
    static func contact(

    ) async throws -> any AsyncResponseEncodable {

        @Dependency(\.language) var translated

        let email = Anchor(
            href: .email(
                "coen@coenttb.com",
                subject: "Let's get in touch - coenttb.com",
                body: "Hi Coen,\n\nI'd love to discuss..."
            )
        ) {
            "coen@coenttb.com"
        }

        let linkedIn = Anchor(
            href: "https://linkedin.com/in/coenttb"
        ) {
            "LinkedIn"
        }

        let github = Anchor(
            href: "https://github.com/coenttb"
        ) {
            "GitHub"
        }

        let x = Anchor(
            href: "https://x.com/coenttb"
        ) {
            "X/Twitter: @coenttb"
        }

        // Location info
        let location = "Amsterdam, Netherlands"
        let timezone = "CET/CEST (UTC+1/+2)"

        // Response time expectation
        let responseTime = TranslatedString(
            dutch: "Ik antwoord meestal binnen 24-48 uren",
            english: "I typically respond within 24-48 hours"
        )

        return Server_Integration.HTMLDocument {
            PageModule(theme: .mainContent) {
                Header(1) {
                    "Let's connect"
                }

                // Introduction paragraph
                HTMLMarkdown {
                    """
                    I'm always interested in discussing new projects, opportunities,
                    or just connecting with fellow entrepreneurs, coders, and lawyers. Whether you're looking to collaborate, have questions about my work, or want to chat about (legal) tech or Swift, I'd love to hear from you.

                    \(responseTime)

                    \(location), \(timezone)
                    """
                }
            }

            PageModule(theme: .mainContent) {
                Header(2) {
                    "Get in touch"
                }

                ul {
                    li {
                        Label {
                            FontAwesomeIcon(icon: "envelope")
                        } title: {
                            email
                        }
                        small { "Best for: Project inquiries, collaborations" }
                    }

                    li {
                        Label {
                            FontAwesomeIcon(icon: "linkedin fa-brands")
                        } title: {
                            linkedIn
                        }
                        small { "Best for: Professional networking" }
                    }

                    li {
                        Label {
                            FontAwesomeIcon(icon: "x-twitter fa-brands")
                        } title: {
                            x
                        }
                        small { "Best for: Quick questions, discussions" }
                    }

                    li {
                        Label {
                            FontAwesomeIcon(icon: "github fa-brands")
                        } title: {
                            github
                        }
                        small { "Best for: code reviews, open source" }
                    }
                }
                .listStyle(.reset)
            }
        }
    }
}

public extension String.StringInterpolation {
    mutating func appendInterpolation(rawHTML value: some HTML) {
        try! appendLiteral(String(value))
    }
}
