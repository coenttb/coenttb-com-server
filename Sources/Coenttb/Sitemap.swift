//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 07-01-2024.
//

import CoenttbWebBlog
import Dependencies
import Foundation
import ServerRouter
import Sitemap

extension [WebsitePage: SiteMap.URL.MetaData] {
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
            .merging([WebsitePage: SiteMap.URL.MetaData](blogPosts: blogPosts())) { current, _ in current }
    }
}

extension [WebsitePage: SiteMap.URL.MetaData] {
    init(blogPosts: [CoenttbWebBlog.Blog.Post]) {
        self = Dictionary(
            uniqueKeysWithValues: blogPosts.enumerated().map { index, post in
                (
                    WebsitePage.blog(.post(index)),
                    SiteMap.URL.MetaData(
                        lastModification: post.publishedAt,
                        changeFrequency: .weekly,
                        priority: .one
                    )
                )
            }
        )
    }
}

extension [SiteMap.URL] {
    init(
        dictionary: [WebsitePage: SiteMap.URL.MetaData]
    ) {
        @Dependency(\.serverRouter) var siteRouter
        self = .init(router: siteRouter.url(for:), dictionary)
    }
}

extension SiteMap {
    init(
        dictionary: [WebsitePage: SiteMap.URL.MetaData]
    ) {
        self = .init(urls: [SiteMap.URL](dictionary: dictionary))
    }
}

extension SiteMap {
    public static func `default`() async throws -> Self { try await SiteMap(dictionary: .default()) }
}
