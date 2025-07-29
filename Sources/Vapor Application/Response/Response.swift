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
    static func response(
        request: Request,
        route: Coenttb_Com_Router.Route
    ) async throws -> any AsyncResponseEncodable {
        @Dependency(\.logger) var logger

        return try await withDependencies {
            $0.request = request
            $0.route = route
            // Necessary to get updated envVars on each request
            $0.envVars = .liveValue
        } operation: {
            return try await withDependencies {
                @Dependency(\.envVars) var envVars
                $0.logger.logLevel = envVars.logLevel ?? logger.logLevel
            } operation: {
                return try await withDependencies { _ in
//                    $0.currentUser = try await currentUser()
                } operation: {

                    @Dependency(\.uuid) var uuid
                    @Dependency(\.coenttb.website.router) var serverRouter
                    @Dependency(\.currentUser) var currentUser

                    switch route {
                    case let .api(api):
                        return try await API.response(api: api)

                    case let .webhook(webhook):
                        return try await Webhook.response(webhook: webhook)

//                    case .website(let page) where page.page == .home && page.language == nil:
//                        return try await Website<Route.Website>.response(website: .init(language: nil, page: .home))

                    case let .website(website):
                        return try await Coenttb_Server.Website<Coenttb_Com_Router.Route.Website>.response(website: website)

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
                        return try await request.fileio.streamFile(at: .favicon(favicon))

                    case let .public(`public`):
                        return try await request.fileio.streamFile(at: `public`)
                    }
                }
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
        @Dependency(\.coenttb.website.router) var serverRouter
        return try await self.asyncStreamFile(at: serverRouter.url(for: .public(`public`)).absoluteString)
    }
}

extension RSS.Feed {
    init(
        posts: [Blog.Post]
    ) {
        @Dependency(\.coenttb.website.router) var serverRouter
        @Dependency(\.envVars.baseUrl) var baseUrl
        @Dependency(\.envVars.companyName) var companyName

        self = RSS.Feed(
            metadata: .init(
                title: companyName ?? "RSS",
                link: baseUrl,
                description: String.oneliner.english,
                imageURL: serverRouter.url(for: .public(.asset(.logo(.favicon_dark))))
            ),
            items: posts.map { RSS.Feed.Item(from: $0, author: companyName ?? "Author") }
        )
    }
}

extension RSS.Feed.Item {
    init(from post: Blog.Post, author: String) {
        @Dependency(\.coenttb.website.router) var serverRouter
        self = RSS.Feed.Item(
            title: post.title,
            link: serverRouter.url(for: .blog(.post(post))),
            image: .init(
                url: serverRouter.url(for: .api(.syndication(.image("Test")))),
                variant: .png
            ),
            creator: author,
            publicationDate: post.publishedAt,
            description: post.blurb
        )
    }
}
