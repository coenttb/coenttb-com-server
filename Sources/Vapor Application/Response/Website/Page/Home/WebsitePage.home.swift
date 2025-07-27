//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 30/05/2022.
//

import Coenttb_Blog
import Coenttb_Com_Router
import Coenttb_Com_Shared
import Coenttb_Newsletter
import Coenttb_Vapor
import Server_Integration
import Server_Translations

extension Coenttb_Com_Router.Route.Website {
    package static func home() async throws -> any AsyncResponseEncodable {
        @Dependency(\.language) var translated
        @Dependency(\.coenttb.website.router) var serverRouter
        @Dependency(\.blog.getAll) var blogPosts
        @Dependency(\.currentUser) var currentUser
        @Dependency(\.newsletter.isSubscribed) var isNewsletterSubscribed

        let posts = blogPosts()

        return HTMLDocument {
            HTMLGroup {
                if currentUser?.authenticated != true {
                    CallToActionModule(
                        title: (
                            content: "\(String.oneliner)",
                            color: .text.primary
                        ),
                        blurb: (
                            content: """
                            \(String.hi_my_name_is_Coen_ten_Thije_Boonkkamp.capitalizingFirstLetter()). \(String.website_introduction.capitalizingFirstLetter().period)
                            \((!posts.isEmpty ? " \(String.follow_my_blog_for.capitalizingFirstLetter().period)" : ""))
                            """,
                            color: .text.primary
                        )
                    ) {
                        div {
                            Link(
                                destination: .newsletter(.subscribe(.request)),
                                String.subscribe_to_my_newsletter.capitalizingFirstLetter().description
                            )
                            .linkColor(.text.primary.reverse())
                            .linkUnderline(false)
                            .fontWeight(.normal)
                            .buttonStyle(background: .branding.primary)

                        }
                        .paddingTop(.medium)

                        small { String.periodically_receive_articles_on }
                            .font(.body(.small))
                            .color(.text.secondary)
                    }
                    .if(currentUser?.authenticated != true) {
                        $0.gradient(
                            bottom: .background.primary,
                            middle: .gradientMidpoint(from: .background.primary, to: .branding.accent)!,
                            top: .branding.accent
                        )
                    }
                }

                if !posts.isEmpty {
                    Coenttb_Blog.Blog.FeaturedModule(
                        posts: posts,
                        seeAllURL: serverRouter.url(for: .blog(.index))
                    )
                    .if(currentUser?.authenticated == true) {
                        $0.gradient(
                            bottom: .background.primary,
                            middle: .gradientMidpoint(from: .background.primary, to: .branding.accent)!,
                            top: .branding.accent
                        )
                    }

                    .backgroundColor(.background.primary)
                }

                if isNewsletterSubscribed != true {
                    div {
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
                            Header(4) {
                                String.subscribe_to_my_newsletter.capitalizingFirstLetter()
                            }
                            .padding(top: .rem(3))
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
//                    .background(currentUser?.authenticated == true ? .background.primary : .background.secondary)
                    .width(.percent(100))
                }

                CallToActionModule(
                    title: (
                        content: TranslatedString(
                            dutch: "Ontdek de rol van legal in het succes van life science projecten",
                            english: "Discover the role of legal in the success of life science projects"
                        ).description,
                        color: .text.primary
                    ),
                    blurb: (
                        content: #"""
                        \#(
                            TranslatedString(
                                dutch: "Ten Thije Boonkkamp is waar ik mijn persoonlijke juridische dienstverlening voor life science projecten aanbiedt",
                                english: "Ten Thije Boonkkamp is where I offer my personal legal services for life science projects"
                            ).period
                        )
                        """#,
                        color: .text.primary
                    )
                ) {
                    div {
                        div {
                            Link(href: .init("https://tenthijeboonkkamp.nl")) {
                                Label {
                                    span { FontAwesomeIcon(icon: "scale-balanced") }
                                        .color(.branding.primary)
                                        .fontWeight(.medium)
                                } title: {
                                    div {
                                        HTMLText("tenthijeboonkkamp.nl" + " →")
                                    }
                                    .color(.branding.primary)
                                    .fontWeight(.medium)
                                }
                            }
                        }
                        .display(.inlineBlock)
                        .margin(top: .rem(3))
                    }
                }
                .backgroundColor(.background.primary)

            }
        }
    }
}
