//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 30/05/2022.
//

import Coenttb
import CoenttbWebBlog
import CoenttbWebHTML
import CoenttbWebModels
import CoenttbWebNewsletter
import Date
import Dependencies
import Foundation
import Languages
import ServerRouter
import ServerTranslations
import Vapor

extension WebsitePage {
    public static func home() async throws -> any AsyncResponseEncodable {
        @Dependency(\.language) var translated
        @Dependency(\.serverRouter) var serverRouter
        @Dependency(\.blog.getAll) var blogPosts
        @Dependency(\.currentUser) var currentUser
        @Dependency(\.request) var request

        let posts = blogPosts()
        let newsletterSubscribed = currentUser?.newsletterSubscribed == true || (currentUser?.newsletterSubscribed == nil && request?.cookies[.newsletterSubscribed]?.string == "true")

        return Coenttb.DefaultHTMLDocument {
            HTMLGroup {
                if currentUser?.authenticated != true {
                    CallToActionModule(
                        title: (
                            content: "\(Coenttb.oneliner)",
                            color: .primary
                        ),
                        blurb: (
                            content: """
                            \(String.hi_my_name_is_Coen_ten_Thije_Boonkkamp.capitalizingFirstLetter()). \(String.website_introduction.capitalizingFirstLetter().period)
                            \((!posts.isEmpty ? " \(String.follow_my_blog_for.capitalizingFirstLetter().period)" : ""))
                            """,
                            color: .primary
                        )
                    )
                    .if(currentUser?.authenticated != true) {
                        $0.gradient(
                            bottom: .white.withDarkColor(.black),
                            middle: .gradientMidpoint(from: .white.withDarkColor(.black), to: .coenttbAccentColor)!,
                            top: .coenttbAccentColor
                        )
                    }
                }

                if !posts.isEmpty {
                    div {
                        CoenttbWebBlog.Blog.FeaturedModule(
                            posts: posts,
                            seeAllURL: serverRouter.url(for: .blog(.index))
                        )
                    }
                    .if(currentUser?.authenticated == true) {
                        $0.gradient(
                            bottom: .white.withDarkColor(.black),
                            middle: .gradientMidpoint(from: .white.withDarkColor(.black), to: .coenttbAccentColor)!,
                            top: .coenttbAccentColor
                        )
                    }
//                    .background(currentUser?.authenticated == true ? .background : .offBackground)
                    .background(.background)
                }

                if newsletterSubscribed != true {
                    div {
                        PageModule(theme: .newsletterSubscription) {
                            VStack {
                                Paragraph {
                                    String.periodically_receive_articles_on.capitalizingFirstLetter().period
                                }
                                .textAlign(.center, media: .desktop)

                                NewsletterSubscriptionForm(
                                    newsletterSubscribeAction: serverRouter.url(for: .api(.v1(.newsletter(.subscribe(.init())))))
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
                    .background(currentUser?.authenticated == true ? .background : .offBackground)
                    .width(100.percent)
                    .id("newsletter-signup")
                }

                CallToActionModule(
                    title: (
                        content: TranslatedString(
                            dutch: "Ontdek de rol van legal in het succes van life science projecten",
                            english: "Discover the role of legal in the success of life science projects"
                        ).description,
                        color: .primary
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
                        color: .primary
                    )
                ) {
                    div {

                        div {
                            Button(
                                tag: a,
                                style: .default,
                                icon: {
                                    span { FontAwesomeIcon(icon: "scale-balanced") }
                                        .color(.coenttbPrimaryColor)
                                        .fontWeight(.medium)
                                },
                                label: {
                                    div {
                                        HTMLText("tenthijeboonkkamp.nl" + " →")
                                    }
                                    .color(.coenttbPrimaryColor)
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
                .background(.background)

            }
        }
    }
}
