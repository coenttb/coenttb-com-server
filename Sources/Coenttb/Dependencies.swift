//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 04-01-2024.
//

import CoenttbWeb
import CoenttbBlog
import CoenttbNewsletter
import CoenttbStripe
import CoenttbStripeLive
import Mailgun
import ServerDatabase
import ServerDependencies
import ServerModels
import ServerRouter

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension BlogKey: @retroactive DependencyKey {
    public static let liveValue: CoenttbBlog.Client = .init(
        getAll: {
            @Dependency(\.envVars.appEnv) var appEnv
            @Dependency(\.date.now) var now

            return [CoenttbBlog.Blog.Post].all
                .filter {
                    appEnv == .production
                    ? $0.publishedAt <= now
                    : true
                }
        },
        filenameToResourceUrl: { fileName in
            Bundle.module.url(forResource: fileName, withExtension: "md")
        },
        postToRoute: { post in
            @Dependency(\.serverRouter) var serverRouter
            return serverRouter.url(for: .blog(.post(post)))
        },
        postToFilename: { post in
                .init { language in
                    (
                        post.hidden == .preview
                        ? "Preview-Blog-\(post.index)"
                        : "Blog-\(post.index)"
                    )
                    + "-\(language.rawValue)"
                }
        }
    )
}

extension DatabaseClientKey: DependencyKey {
    public static let liveValue: ServerDatabase.Client = {
        @Dependency(\.request?.db) var database

        guard
            let database
        else {
            return ServerDatabase.Client.noop
        }

        return .live(database: database)
    }()
}

extension PreviewPostKey: DependencyKey {
    public static let liveValue: @Sendable () -> [CoenttbBlog.Blog.Post] = {
        @Dependency(\.envVars.appEnv) var appEnv
        @Dependency(\.date.now) var now

        return [CoenttbBlog.Blog.Post].preview
            .filter {
                appEnv == .production
                ? $0.publishedAt <= now
                : true
            }
    }
}

extension CurrentUserKey: DependencyKey {
    public static let liveValue: User? = nil
}

extension ServerRouterKey: DependencyKey {
    public static let liveValue: ServerRouter = {
        @Dependency(\.envVars) var envVars
        return ServerRouter(
            baseURL: envVars.baseUrl,
            apiRouter: API.Router.shared,
            webhookRouter: Webhook.Router.shared,
            publicRouter: Public.Router.shared,
            pageRouter: WebsitePage.Router.shared
        )
    }()
}

extension SQLPostgresConfigurationKey: @retroactive DependencyKey {
    public static var liveValue: SQLPostgresConfiguration {

        @Dependency(\.envVars.emergencyMode) var emergencyMode
        @Dependency(\.envVars.postgres.databaseUrl) var postgresDatabaseUrl

        return .liveValue(
            emergencyMode: emergencyMode,
            postgresDatabaseUrl: postgresDatabaseUrl)
    }
}

extension EventLoopGroupConnectionPoolKey: @retroactive DependencyKey {
    public static var liveValue: EventLoopGroupConnectionPool<PostgresConnectionSource> {
        @Dependency(\.mainEventLoopGroup) var mainEventLoopGroup
        @Dependency(\.sqlConfiguration) var sqlConfiguration

        return .init(
            source: PostgresConnectionSource(sqlConfiguration: sqlConfiguration),
            on: mainEventLoopGroup
        )
    }
}

extension Logger: @retroactive DependencyKey {
    public static let liveValue: Self = {
        @Dependency(\.envVars) var envVars
        var logger = Logger(label: ProcessInfo.processInfo.processName) { _ in
            CoenttbLogHandler(label: "coenttb", logLevel: envVars.logLevel ?? .trace, metadataProvider: nil)
        }
        return logger
    }()
}

extension Mailgun.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.Client? {
        @Dependency(\.envVars) var envVars

        guard
            let baseUrl = envVars.mailgun?.baseUrl,
            let apiKey = envVars.mailgun?.apiKey,
            let domain = envVars.mailgun?.domain
        else {
            return nil
        }

        return Mailgun.Client.live(
            apiKey: apiKey,
            baseUrl: .init(string: baseUrl) ?? URL.mailgun_eu_baseUrl,
            domain: domain.rawValue,
            session: { try await URLSession.shared.data(for: $0) }
        )
    }
}

extension StripeClientKey: @retroactive DependencyKey {
    public static var liveValue: CoenttbStripe.Client? {
        @Dependency(\.envVars) var envVars
        @Dependency(\.httpClient) var httpClient

        guard
            let stripeSecretKey = envVars.stripe?.secretKey
        else {
            return nil
        }

        return CoenttbStripe.Client.live(
            stripeSecretKey: stripeSecretKey,
            httpClient: httpClient
        )
    }
}

extension DatabaseConfigurationKey: @retroactive DependencyKey {
    public static let liveValue = DatabaseConfiguration(
        maxConnectionsPerEventLoop: 1,
        connectionPoolTimeout: .seconds(10)
    )
}
