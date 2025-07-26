//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 07-01-2024.
//

import Coenttb_Blog
import Coenttb_Com_Router
import Coenttb_Com_Shared
import Dependencies
import Foundation
import Sitemap

extension [Coenttb_Com_Router.Route.Website: Sitemap.URL.MetaData] {
    static func `default`() async throws -> Self {

        @Dependency(\.blog.getAll) var blogPosts
        return [
            .home: .init(
                lastModification: nil,
                changeFrequency: .weekly,
                priority: .one
            ),
            .blog(.index): .init(
                lastModification: nil,
                changeFrequency: .weekly,
                priority: .one
            ),
            .privacy_statement: .empty,
            .terms_of_use: .empty,
            .general_terms_and_conditions: .empty
        ]
            .merging([Coenttb_Com_Router.Route.Website: Sitemap.URL.MetaData](blogPosts: blogPosts())) { current, _ in current }
    }
}

extension [Coenttb_Com_Router.Route.Website: Sitemap.URL.MetaData] {
    init(blogPosts: [Coenttb_Blog.Blog.Post]) {
        self = Dictionary(
            uniqueKeysWithValues: blogPosts.enumerated().map { index, post in
                (
                    Route.Website.blog(.post(index)),
                    Sitemap.URL.MetaData(
                        lastModification: post.publishedAt,
                        changeFrequency: .weekly,
                        priority: .one
                    )
                )
            }
        )
    }
}

extension [Sitemap.URL] {
    init(
        dictionary: [Coenttb_Com_Router.Route.Website: Sitemap.URL.MetaData]
    ) {
        @Dependency(\.coenttb.website.router) var serverRouter
        self = .init(router: serverRouter.url(for:), dictionary)
    }
}

extension Sitemap {
    init(
        dictionary: [Coenttb_Com_Router.Route.Website: Sitemap.URL.MetaData]
    ) {
        self = .init(urls: [Sitemap.URL](dictionary: dictionary))
    }
}

extension Sitemap {
    package static func `default`() async throws -> Self { try await Sitemap(dictionary: .default()) }
}
