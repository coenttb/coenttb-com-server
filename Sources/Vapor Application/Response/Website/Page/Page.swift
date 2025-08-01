//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 31-12-2023.
//

import Coenttb_Blog_Vapor
import Coenttb_Com_Router
import Coenttb_Com_Shared
import Coenttb_Newsletter
import Coenttb_Vapor
import Server_EnvVars
import Server_Integration

extension Coenttb_Com_Router.Route.Website {
    static func response(
        page: Coenttb_Com_Router.Route.Website
    ) async throws -> any AsyncResponseEncodable {
        switch page {
        case let .blog(route):
            let response = try await Blog.Route.View.response(route: route)

            return HTMLDocument(themeColor: .background.primary) {
                AnyHTML(response)
            }

        case .choose_country_region:
            return try await Coenttb_Com_Router.Route.Website.choose_country_region()

        case .contact:
            return try await Coenttb_Com_Router.Route.Website.contact()

        case .general_terms_and_conditions:
            return try await Coenttb_Com_Router.Route.Website.general_terms_and_conditions()

        case .home:
            return try await Coenttb_Com_Router.Route.Website.home()

        case .privacy_statement:
            return try await Coenttb_Com_Router.Route.Website.privacy_policy()

        case .terms_of_use:
            return try await Coenttb_Com_Router.Route.Website.termsOfUse()

        case let .newsletter(newsletter) where newsletter == .subscribe(.request):
            @Dependency(\.coenttb.website.router) var router
            return Server_Integration.HTMLDocument {
                Circle {
                    Image.coenttbGreenSuit
                        .objectPosition(.twoValues(.percentage(50), .percentage(50)))
                }

                .position(.relative)
                .size(.rem(10))
                .padding(top: .length(.large))
                .flexContainer(
                    justification: .center,
                    itemAlignment: .center
                )

                PageModule(theme: .newsletterSubscription) {

                    VStack {
                        CoenttbHTML.Paragraph {
                            String.periodically_receive_articles_on.capitalizingFirstLetter().period
                        }
                        .textAlign(.center, media: .desktop)

                        @Dependency(\.newsletter.subscribeAction) var subscribeAction

                        NewsletterSubscriptionForm(
                            subscribeAction: subscribeAction()
                        )
                        .width(.percent(100))
                    }
                    .width(.percent(100))
                    .maxWidth(.rem(30), media: .desktop)
                    .flexContainer(
                        direction: .column,
                        wrap: .wrap,
                        justification: .center,
                        itemAlignment: .center,
                        rowGap: .rem(0.5)
                    )
                }
                title: {
                    Header(2) {
                        String.subscribe_to_my_newsletter.capitalizingFirstLetter()
                    }
                    .padding(top: .medium)
                }
                .flexContainer(
                    justification: .center,
                    itemAlignment: .center,
                    media: .desktop
                )
                .flexContainer(
                    justification: .start,
                    itemAlignment: .start,
                    media: .mobile
                )
            }

        case let .newsletter(newsletter):
            return try await Newsletter.Route.View.response(
                newsletter: newsletter,
                htmlDocument: { html in
                    Server_Integration.HTMLDocument {
                        AnyHTML(html)
                    }
                }
            )
        }
    }
}

extension Coenttb_Com_Router.Route.Website {
    static func choose_country_region() async throws
    -> any AsyncResponseEncodable {
        @Dependency(\.envVars.languages) var languages
        @Dependency(\.language) var language
        @Dependency(\.coenttb.website.router) var router

        throw Abort(.internalServerError)
    }
}

extension Coenttb_Com_Router.Route.Website {
    static func dashboard() async throws -> any AsyncResponseEncodable {

        @Dependency(\.envVars.companyXComHandle) var companyXComHandle

        return Server_Integration.HTMLDocument {
            PageHeader(
                title: "Welcome back"
            ) {
                HTMLGroup {
                    span { "Want to see what’s coming up next? " }

                    if let companyXComHandle {
                        Link(href: .init("https://x.com/\(companyXComHandle)")) {
                            "Follow me on Twitter."
                        }
                            .linkUnderline(true)
                    }
                }
                .color(.gray300.withDarkColor(.gray800))
            }
            .gradient(bottom: .background.primary, middle: .branding.accent, top: .branding.accent)
        }
    }
}

extension Coenttb_Com_Router.Route.Website {
    static func privacy_policy() async throws -> any AsyncResponseEncodable {

        @Dependency(\.language) var language

        return Server_Integration.HTMLDocument {
            PageHeader(
                title: .privacyStatement.capitalizingFirstLetter().description
            ) {
            }

            PageModule(
                theme: .content
            ) {
                TextArticle {
                    Clauses.privacyStatement(language)
                }
            }
        }
    }
}

extension Coenttb_Com_Router.Route.Website {
    static func termsOfUse() async throws -> any AsyncResponseEncodable {

        @Dependency(\.language) var language

        return Server_Integration.HTMLDocument {
            PageHeader(
                title: .terms_of_use.capitalizingFirstLetter().description
            ) {
            }

            PageModule(
                theme: .content
            ) {
                TextArticle {
                    Clauses.termsOfUse(language)
                }
            }
        }
    }
}

extension Coenttb_Com_Router.Route.Website {
    static func general_terms_and_conditions() async throws
    -> any AsyncResponseEncodable {

        @Dependency(\.language) var language

        return Server_Integration.HTMLDocument {
            PageHeader(
                title: .general_terms_and_conditions.capitalizingFirstLetter().description
            ) {
            }

            PageModule(
                theme: .content
            ) {
                TextArticle {
                    Clauses.generalTermsAndConditions(language)
                }
            }
        }
    }
}
