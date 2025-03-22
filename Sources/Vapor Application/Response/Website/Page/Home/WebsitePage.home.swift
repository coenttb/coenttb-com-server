//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 30/05/2022.
//

import Coenttb_Vapor
import Server_Application
import Coenttb_Blog
import Coenttb_Newsletter
import Coenttb_Com_Shared
import Server_Translations
import Coenttb_Com_Router

extension WebsitePage {
    public static func home() async throws -> any AsyncResponseEncodable {
        @Dependency(\.language) var translated
        @Dependency(\.coenttb.website.router) var serverRouter
        @Dependency(\.blog.getAll) var blogPosts
        @Dependency(\.currentUser) var currentUser
        @Dependency(\.request) var request

        let posts = blogPosts()
        let newsletterSubscribed = currentUser?.newsletterSubscribed == true || (currentUser?.newsletterSubscribed == nil && request?.cookies[.newsletterSubscribed]?.string == "true")

        return Server_Application.DefaultHTMLDocument {
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
                    )
                    .if(currentUser?.authenticated != true) {
                        $0.gradient(
                            bottom: .background.primary,
                            middle: .gradientMidpoint(from: .background.primary, to: .branding.accent)!,
                            top: .branding.accent
                        )
                    }
                }

                if !posts.isEmpty {
                    div {
                        Coenttb_Blog.Blog.FeaturedModule(
                            posts: posts,
                            seeAllURL: serverRouter.url(for: .blog(.index))
                        )
                    }
                    .if(currentUser?.authenticated == true) {
                        $0.gradient(
                            bottom: .background.primary,
                            middle: .gradientMidpoint(from: .background.primary, to: .branding.accent)!,
                            top: .branding.accent
                        )
                    }
//                    .background(currentUser?.authenticated == true ? .background : .offBackground)
                    .background(.background.primary)
                }

                if newsletterSubscribed != true {
                    div {
                        PageModule(theme: .newsletterSubscription) {
                            VStack {
                                Paragraph {
                                    String.periodically_receive_articles_on.capitalizingFirstLetter().period
                                }
                                .textAlign(.center, media: .desktop)

                                @Dependency(\.newsletter.subscribeAction) var subscribeAction
                                
                                NewsletterSubscriptionForm(
                                    subscribeAction: subscribeAction()
                                )
                                .width(100.percent)
                            }
                            .width(100.percent)
                            .maxWidth(30.rem, media: .desktop)
                            .flexContainer(
                                direction: .column,
                                wrap: .wrap,
                                justification: .center,
                                itemAlignment: .center,
                                rowGap: .length(0.5.rem)
                            )
                        }
                        title: {
                            Header(4) {
                                String.subscribe_to_my_newsletter.capitalizingFirstLetter()
                            }
                            .padding(top: 3.rem)
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
                    .background(currentUser?.authenticated == true ? .background.primary : .background.secondary)
                    .width(100.percent)
                    .id("newsletter-signup")
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
                            Button(
                                tag: a,
                                style: .default,
                                icon: {
                                    span { FontAwesomeIcon(icon: "scale-balanced") }
                                        .color(.branding.primary)
                                        .fontWeight(.medium)
                                },
                                label: {
                                    div {
                                        HTMLText("tenthijeboonkkamp.nl" + " →")
                                    }
                                    .color(.branding.primary)
                                    .fontWeight(.medium)

                                }
                            )
                            .href("https://tenthijeboonkkamp.nl")
                        }
                        .display(.inlineBlock)
                        .margin(top: 3.rem)
                    }
                }
//                .background(currentUser?.authenticated == true ? .offBackground : .background)
                .background(.background.primary)

            }
        }
    }
}
