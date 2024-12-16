//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 31-12-2023.
//

import Coenttb
import CoenttbMarkdown
import CoenttbWebBlog
import CoenttbWebHTML
import CoenttbWebNewsletter
import Dependencies
import Foundation
import Languages
import ServerDependencies
import ServerRouter
import Vapor

//extension CoenttbWebBlog.Route {
//    static func response(
//        blog: CoenttbWebBlog.Route
//    ) async throws -> any AsyncResponseEncodable {
//        switch blog {
//        case .index:
//            @Dependency(\.blog.getAll) var blogPosts
//            @Dependency(\.envVars.companyXComHandle!) var companyXComHandle
//
//            let localPosts = blogPosts()
//
//            let header = {
//                PageHeader(
//                    title: .blog.capitalizingFirstLetter().description,
//                    blurb: {
//                        HTMLText(Coenttb.oneliner.description)
//                    }
//                ) {
//                    HTMLGroup {
//                        HTMLText(String.curious_what_is_next.description.capitalizingFirstLetter().questionmark.description)
//                        Link(String.follow_me_on_Twitter.capitalizingFirstLetter().period.description, href: "https://x.com/\(companyXComHandle)")
//                            .linkUnderline(true)
//                    }
//                    .color(.gray300.withDarkColor(.gray800))
//                }
//            }
//
//            switch localPosts.count {
//            case 0:
//                return Coenttb.DefaultHTMLDocument(themeColor: .white.withDarkColor(.black)) {
//                    header()
//                }
//            case 1:
//                return try await CoenttbWebBlog.Route.response(blog: .post(localPosts.lazy.first!))
//            default:
//
//                @Dependency(\.serverRouter) var serverRouter
//                return Coenttb.DefaultHTMLDocument(themeColor: .white.withDarkColor(.black)) {
//                    header()
//
//                    CoenttbWebBlog.Blog.AllPostsModule(
//                        posts: blogPosts()
//                    )
//                }
//            }
//
//        case .post(let index):
//            @Dependency(\.blog.getAll) var blogPosts
//            @Dependency(\.currentUser) var currentUser
//            @Dependency(\.serverRouter) var serverRouter
//
//            guard
//                let post = blogPosts().lazy.first(where: {
//                    switch index {
//                    case .left(let string):
//                        $0.slug == string
//                    case .right(let int):
//                        $0.index == int
//                    }
//                })
//            else {
//                return try await CoenttbWebBlog.Route.response(blog: .index)
//            }
//
//            guard !(post.permission == .subscriberOnly && currentUser?.accessToBlog != true)
//            else {
//                return Coenttb.DefaultHTMLDocument(themeColor: .white.withDarkColor(.black)) {
//                    Header(1) {
//                        TranslatedString(
//                            dutch: "Alleen voor subscribers",
//                            english: "Subscriber only"
//                        )
//                    }
//                }
//            }
//
//            return Coenttb.DefaultHTMLDocument(themeColor: .white.withDarkColor(.black)) {
//                Blog.Post.View(post: post)
//
//                CoenttbWebNewsletter.Route.Subscribe.Overlay(
//                    image: Image.coenttbGreenSuit,
//                    title: String.keep_in_touch_with_Coen.capitalizingFirstLetter().description,
//                    caption: String.you_will_periodically_receive_articles_on.capitalizingFirstLetter().period.description,
//                    newsletterSubscribed: currentUser?.newsletterSubscribed == true,
//                    newsletterSubscribeAction: serverRouter.url(for: .api(.v1(.newsletter(.subscribe(.init())))))
//                )
//            }
//        }
//    }
//}
