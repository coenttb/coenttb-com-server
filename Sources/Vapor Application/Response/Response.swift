//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 28/06/2022.
//

import Coenttb
import Coenttb_Server
import Coenttb_Blog
import Coenttb_Syndication_Vapor
import Server_EnvVars
import Server_Models
import Coenttb_Com_Shared
import Server_Dependencies
import Coenttb_Com_Router

extension Coenttb_Com_Router.Route {
    static func response(
        request: Request,
        route: Coenttb_Com_Router.Route
    ) async throws -> any AsyncResponseEncodable {
        @Dependency(\.logger) var logger
        /*@Dependency(\.serverClient.account.currentUser) */var currentUser = ""
        
        return try await withDependencies {
            $0.envVars = .liveValue
        } operation: {
            return try await withDependencies {
                @Dependency(\.envVars) var envVars
                $0.request = request
                $0.route = route
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
                        
                    case .website(let page) where page.page == .home:
                        return try await Website<WebsitePage>.response(website: .init(language: nil, page: .home))
                        
                    case let .website(website):
                        return try await Website<WebsitePage>.response(website: website)
                        
                    case .public(.sitemap):
                        return Response(
                            status: .ok,
                            body: .init(stringLiteral: try await SiteMap.default().xml)
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
                        let disallows = Languages.Language.allCases.map {
                        """
                        Disallow: /\($0.rawValue)/account/
                        Disallow: /\($0.rawValue)/checkout/
                        """
                        }.joined(separator: "\n")
                        
                        return Response.robots(
                            disallows: disallows
                        )
                        
                    case .public(.wellKnown(.apple_developer_merchantid_domain_association)):
                        @Dependency(\.envVars.appleDeveloperMerchantIdDomainAssociation) var appleDeveloperMerchantIdDomainAssociation
                        if let appleDeveloperMerchantIdDomainAssociation {
                            return appleDeveloperMerchantIdDomainAssociation
                        } else {
                            throw Abort(.internalServerError, reason: "Failed to get apple-developer-merchantid-domain-association")
                        }
                        
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


extension FileIO {
    func streamFile(at public: Public) async throws -> Vapor.Response {
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
                description: Coenttb.oneliner.english,
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


extension Coenttb.DefaultHTMLDocument: AsyncResponseEncodable {}



//case .create, .delete, .login, .logout, .password, .emailChange:
//    guard let route = Coenttb_Identity.Route(account) else { throw Abort(.internalServerError) }
//
//    @Dependency(\.serverClient.account) var accountDependency
//    @Dependency(\.envVars.canonicalHost) var canonicalHost
//
//    return try await Coenttb_Identity.Route.response(
//        route: route,
//        logo: .coenttb,
//        canonicalHref: serverRouter.url(for: .account(account)),
//        favicons: .coenttb,
//        hreflang: { serverRouter.url(for: .init(language: $1, page: .account(account))) },
//        termsOfUse: serverRouter.url(for: .terms_of_use),
//        privacyStatement: serverRouter.url(for: .privacy_statement),
//        dependency: accountDependency,
//        primaryColor: .coenttbPrimaryColor,
//        accentColor: .coenttbAccentColor,
//        homeHref: serverRouter.url(for: .home),
//        loginHref: serverRouter.url(for: .account(.login)),
//        accountCreateHref: serverRouter.url(for: .identity(.create(.request))),
//        createFormAction: serverRouter.url(for: .api(.v1(.identity(.create(.request(.init())))))),
//        verificationAction: serverRouter.url(for: .api(.v1(.identity(.create(.verify(.init())))))),
//        verificationSuccessRedirect: serverRouter.url(for: .account(.login)),
//        passwordResetHref: serverRouter.url(for: .account(.password(.reset(.request)))),
//        loginFormAction: serverRouter.url(for: .api(.v1(.account(.login(.init()))))),
//        logout: {
//            @Dependency(\.serverClient.account) var accountDependency
//            try await accountDependency.logout()
//        },
//        passwordChangeRequestAction: serverRouter.url(for: .api(.v1(.account(.password(.change(.request(change: .init()))))))),
//        passwordResetAction: serverRouter.url(for: .api(.v1(.account(.password(.reset(.request(.init()))))))),
//        passwordResetConfirmAction: serverRouter.url(for: .api(.v1(.account(.password(.reset(.confirm(.init()))))))),
//        passwordResetSuccessRedirect: serverRouter.url(for: .account(.login)),
//        currentUserName: {
//            @Dependency(\.currentUser?.name) var name
//            return name
//        },
//        currentUserIsAuthenticated: {
//            @Dependency(\.currentUser?.authenticated) var authenticated
//            return authenticated
//        },
//        emailChangeReauthorizationAction: serverRouter.url(for: .api(.v1(.account(.emailChange(.reauthorization(.init())))))),
//        emailChangeReauthorizationSuccessRedirect: serverRouter.url(for: .account(.emailChange(.request))),
//        requestEmailChangeAction: serverRouter.url(for: .api(.v1(.account(.emailChange(.request(.init())))))),
//        confirmEmailChangeSuccessRedirect: serverRouter.url(for: .account(.login))
//    )
