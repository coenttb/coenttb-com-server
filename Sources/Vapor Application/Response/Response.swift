//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 28/06/2022.
//

import Coenttb_Blog
import Coenttb_Com_Router
import Coenttb_Com_Shared
import Coenttb_Server
import Coenttb_Syndication_Vapor
import Server_Dependencies
import Server_EnvVars
import Server_Integration
import Server_Models

extension Coenttb_Com_Router.Route {
    public static func response(
        route: Coenttb_Com_Router.Route
    ) async throws -> any AsyncResponseEncodable {
        return try await withDependencies {
            $0.route = route
        } operation: {

            switch route {
            case let .api(api):
                return try await API.response(api: api)

            case let .webhook(webhook):
                return try await Webhook.response(webhook: webhook)

            case let .website(website):
                return try await Coenttb_Web.Website<Coenttb_Com_Router.Route.Website>.response(website: website)

            case .public(.sitemap):
                return Response(
                    status: .ok,
                    body: .init(stringLiteral: try await Sitemap.default().xml)
                )

            case .public(.rssXml):

                @Dependency(\.blog.getAll) var blogPosts

                return await RSS.Feed.Response(
                    feed: RSS.Feed.memoized {
                        RSS.Feed(
                            posts: blogPosts()
                        )
                    }
                )

            case .public(.robots):
                return Response.robots(
                    disallows: Translating.Language.allCases.map {
                    """
                    Disallow: /\($0.rawValue)/account/
                    Disallow: /\($0.rawValue)/checkout/
                    """
                    }.joined(separator: "\n")
                )

            case .public(.wellKnown(.apple_developer_merchantid_domain_association)):
                @Dependency(\.envVars.appleDeveloperMerchantIdDomainAssociation) var appleDeveloperMerchantIdDomainAssociation

                guard let appleDeveloperMerchantIdDomainAssociation
                else { throw Abort(.internalServerError, reason: "Failed to get apple-developer-merchantid-domain-association") }

                return appleDeveloperMerchantIdDomainAssociation

            case let .public(.favicon(favicon)):
                @Dependency(\.request!) var request
                return try await request.fileio.streamFile(at: .favicon(favicon))

            case let .public(`public`):
                @Dependency(\.request!) var request
                return try await request.fileio.streamFile(at: `public`)
            }

        }
    }
}

extension Server_Integration.HTMLDocument: AsyncResponseEncodable {
    package func encodeResponse(for request: Vapor.Request) async throws -> Vapor.Response {
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "text/html")
        return .init(status: .ok, headers: headers, body: .init(data: Data(self.render())))
    }
}

extension FileIO {
    func streamFile(at public: Coenttb_Com_Router.Route.Public) async throws -> Vapor.Response {
        @Dependency(\.coenttb.website.router) var router
        return try await self.asyncStreamFile(at: router.url(for: .public(`public`)).absoluteString)
    }
}

extension RSS.Feed {
    init(
        posts: [Blog.Post]
    ) {
        @Dependency(\.coenttb.website.router) var router
        @Dependency(\.envVars.baseUrl) var baseUrl
        @Dependency(\.envVars.companyName) var companyName

        self = RSS.Feed(
            metadata: .init(
                title: companyName ?? "RSS",
                link: baseUrl,
                description: String.oneliner.english,
                imageURL: router.url(for: .public(.asset(.logo(.favicon_dark))))
            ),
            items: posts.map { RSS.Feed.Item(from: $0, author: companyName ?? "Author") }
        )
    }
}

extension RSS.Feed.Item {
    init(from post: Blog.Post, author: String) {
        @Dependency(\.coenttb.website.router) var router
        self = RSS.Feed.Item(
            title: post.title,
            link: router.url(for: .blog(.post(post))),
            image: .init(
                url: router.url(for: .api(.syndication(.image("Test")))),
                variant: .png
            ),
            creator: author,
            publicationDate: post.publishedAt,
            description: post.blurb
        )
    }
}
