//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 31-12-2023.
//

import Coenttb
import Coenttb_Server
import Coenttb_Blog
import Coenttb_Newsletter
import Server_EnvVars
import Server_Router

extension WebsitePage {
    static func response(
        page: WebsitePage
    ) async throws -> any AsyncResponseEncodable {
        return try await withDependencies {
            $0.route = .website(
                .init(language: $0.route.website?.language, page: page))
        } operation: {
            switch page {
            case let .account(account):
                return try await WebsitePage.Account.response(account: account)

            case let .blog(route):
                @Dependency(\.blog.getAll) var blogPosts
                @Dependency(\.envVars.companyXComHandle) var companyXComHandle

                let localPosts = blogPosts()

                return try await Coenttb_Blog.Route.response(
                    route: route,
                    blurb: Coenttb.oneliner,
                    companyXComHandle: companyXComHandle,
                    getCurrentUser: {
                        @Dependency(\.currentUser) var currentUser
                        guard
                            let newsletterSubscribed = currentUser?.newsletterSubscribed,
                            let accessToBlog = currentUser?.accessToBlog
                        else { return nil }

                        return (newsletterSubscribed: newsletterSubscribed, accessToBlog: accessToBlog)
                    },
                    coenttbWebNewsletter: {
                        @Dependency(\.serverRouter) var serverRouter
                        @Dependency(\.currentUser) var currentUser

                        return Coenttb_Newsletter.Route.Subscribe.Overlay (
                            image: Image.coenttbGreenSuit,
                            title: String.keep_in_touch_with_Coen.capitalizingFirstLetter().description,
                            caption: String.you_will_periodically_receive_articles_on.capitalizingFirstLetter().period.description,
                            newsletterSubscribed: currentUser?.newsletterSubscribed == true,
                            newsletterSubscribeAction: serverRouter.url(for: .api(.v1(.newsletter(.subscribe(.request(.init()))))))
                        )
                    },
                    defaultDocument: { closure in
                        return Coenttb.DefaultHTMLDocument(themeColor: .white.withDarkColor(.black)) {
                            AnyHTML(closure())
                        }
                    },
                    posts: localPosts
                )

            case .choose_country_region:
                return try await WebsitePage.choose_country_region()

            case .contact:
                return try await WebsitePage.contact()

            case .general_terms_and_conditions:
                return try await WebsitePage.general_terms_and_conditions()

            case .home:
                @Dependency(\.currentUser) var currentUser
                return try await WebsitePage.home()

            case .privacy_statement:
                return try await WebsitePage.privacy_policy()

            case .terms_of_use:
                return try await WebsitePage.termsOfUse()

            case let .newsletter(newsletter):

                @Dependency(\.serverRouter) var serverRouter

                return try await Coenttb_Newsletter.Route.response(
                    newsletter: newsletter,
                    htmlDocument: { html in
                        Coenttb.DefaultHTMLDocument.init {
                            AnyHTML(html)
                        }
                    },
                    subscribeCaption: { String.subscribe_to_my_newsletter.capitalizingFirstLetter().description },
                    subscribeAction: { serverRouter.url(for: .api(.v1(.newsletter(.subscribe(.request(.init())))))) },
                    verificationAction: { verify in serverRouter.url(for: .api(.v1(.newsletter(.subscribe(.verify(.init(token: verify.token, email: verify.email))))))) },
                    verificationRedirectURL: { serverRouter.url(for: .home) },
                    newsletterUnsubscribeAction: { serverRouter.url(for: .api(.v1(.newsletter(.unsubscribe(.init()))))) },
                    form_id: { "coenttb-web-newsletter-route-unsubscribe-view" },
                    localStorageKey: { String.newsletterSubscribed }
                )
            }
        }
    }
}

extension WebsitePage {
    static func choose_country_region() async throws
    -> any AsyncResponseEncodable {
        @Dependency(\.envVars.languages) var languages
        @Dependency(\.language) var language
        @Dependency(\.serverRouter) var siteRouter

        throw Abort(.internalServerError)
    }
}

extension WebsitePage {
    static func dashboard() async throws -> any AsyncResponseEncodable {

        @Dependency(\.envVars.companyXComHandle) var companyXComHandle

        return Coenttb.DefaultHTMLDocument {
            PageHeader(
                title: "Welcome back"
            ) {
                HTMLGroup {
                    span { "Want to see what’s coming up next? " }

                    if let companyXComHandle {
                        Link("Follow me on Twitter.", href: "https://x.com/\(companyXComHandle)")
                            .linkUnderline(true)
                            .linkColor(.coenttbLinkColor)
                    }
                }
                .color(.gray300.withDarkColor(.gray800))
            }
            .gradient(bottom: .white.withDarkColor(.black), middle: .coenttbAccentColor, top: .coenttbAccentColor)
        }
    }
}

extension WebsitePage {
    static func privacy_policy() async throws -> any AsyncResponseEncodable {

        @Dependency(\.language) var language

        return Coenttb.DefaultHTMLDocument {
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

extension WebsitePage {
    static func termsOfUse() async throws -> any AsyncResponseEncodable {

        @Dependency(\.language) var language

        return Coenttb.DefaultHTMLDocument {
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

extension WebsitePage {
    static func general_terms_and_conditions() async throws
    -> any AsyncResponseEncodable {

        @Dependency(\.language) var language

        return Coenttb.DefaultHTMLDocument {
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
