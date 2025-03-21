//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 31-12-2023.
//

import Coenttb_Vapor
import Coenttb_Blog_Vapor
import Coenttb_Newsletter
import Server_Application
import Server_EnvVars
import Coenttb_Com_Shared
import Coenttb_Com_Router
import Coenttb_Identity_Consumer


extension WebsitePage {
    static func response(
        page: WebsitePage
    ) async throws -> any AsyncResponseEncodable {
        return try await withDependencies {
            $0.route = .website(.init(language: $0.route?.website?.language, page: page))
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
                    blurb: String.oneliner,
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
                        @Dependency(\.coenttb.website.router) var serverRouter
                        @Dependency(\.currentUser) var currentUser

                        return Coenttb_Newsletter.View.Subscribe.Overlay (
                            image: Image.coenttbGreenSuit,
                            title: String.keep_in_touch_with_Coen.capitalizingFirstLetter().description,
                            caption: String.you_will_periodically_receive_articles_on.capitalizingFirstLetter().period.description,
                            newsletterSubscribed: currentUser?.newsletterSubscribed == true
                        )
                    },
                    defaultDocument: { closure in
                        return Server_Application.DefaultHTMLDocument(themeColor: .background.primary) {
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
                return try await Coenttb_Newsletter.View.response(
                    newsletter: newsletter,
                    htmlDocument: { html in
                        Server_Application.DefaultHTMLDocument.init {
                            AnyHTML(html)
                        }
                    }
                )
            case .identity(let identity):
                return try await Identity.Consumer.View.response(view: identity)
            }
        }
    }
}

extension WebsitePage {
    static func choose_country_region() async throws
    -> any AsyncResponseEncodable {
        @Dependency(\.envVars.languages) var languages
        @Dependency(\.language) var language
        @Dependency(\.coenttb.website.router) var serverRouter

        throw Abort(.internalServerError)
    }
}

extension WebsitePage {
    static func dashboard() async throws -> any AsyncResponseEncodable {

        @Dependency(\.envVars.companyXComHandle) var companyXComHandle

        return Server_Application.DefaultHTMLDocument {
            PageHeader(
                title: "Welcome back"
            ) {
                HTMLGroup {
                    span { "Want to see what’s coming up next? " }

                    if let companyXComHandle {
                        Link("Follow me on Twitter.", href: "https://x.com/\(companyXComHandle)")
                            .linkUnderline(true)
                    }
                }
                .color(.gray300.withDarkColor(.gray800))
            }
            .gradient(bottom: .background.primary, middle: .branding.accent, top: .branding.accent)
        }
    }
}

extension WebsitePage {
    static func privacy_policy() async throws -> any AsyncResponseEncodable {

        @Dependency(\.language) var language

        return Server_Application.DefaultHTMLDocument {
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

        return Server_Application.DefaultHTMLDocument {
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

        return Server_Application.DefaultHTMLDocument {
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
