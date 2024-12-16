//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 28/06/2022.
//

import Coenttb
import CoenttbWebDependencies
import CoenttbWebHTML
import Dependencies
import EnvVars
import Languages
import ServerModels
import ServerRouter
import Sitemap
import Vapor

extension ServerRoute {
    static func response(
        request: Request,
        route: ServerRoute
    ) async throws -> any AsyncResponseEncodable {
        @Dependency(\.logger) var logger
        @Dependency(\.database.account.currentUser) var currentUser

        return try await withDependencies {
            $0.envVars = .liveValue
        } operation: {

            return try await withDependencies {
                @Dependency(\.envVars) var envVars
                $0.request = request
                $0.route = route
                $0.logger.logLevel = envVars.logLevel ?? logger.logLevel
            } operation: {
                return try await withDependencies {
                    $0.currentUser = try await currentUser()
                } operation: {

                    @Dependency(\.uuid) var uuid
                    @Dependency(\.serverRouter) var siteRouter
                    @Dependency(\.currentUser) var currentUser

                    switch route {
                    case let .api(api):
                        return try await API.response(api: api)

                    case let .webhook(webhook):
                        return try await Webhook.response(webhook: webhook)

                    case .index:
                        return try await Website<WebsitePage>.response(website: .init(language: nil, page: .home))

                    case let .website(website):
                        return try await Website<WebsitePage>.response(website: website)

                    case .public(.sitemap):
                        return Response(
                            status: .ok,
                            body: .init(stringLiteral: try await SiteMap.default().xml)
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
                        return request.fileio.streamFile(at: .favicon(favicon))

                    case let .public(`public`):
                        return request.fileio.streamFile(at: `public`)
                    }
                }
            }
        }
    }
}

extension FileIO {
    func streamFile(at public: Public) -> Vapor.Response {
        @Dependency(\.serverRouter) var siteRouter
        return self.streamFile(at: siteRouter.url(for: .public(`public`)).absoluteString)
    }
}
