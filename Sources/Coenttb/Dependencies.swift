//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 04-01-2024.
//

import CoenttbVapor
import CoenttbWebBlog
import CoenttbWebStripe
import CoenttbWebStripeLive
import Dependencies
import Fluent
import FluentKit
import FluentPostgresDriver
import Foundation
import GitHub
import LoggingDependencies
import Mailgun
import CoenttbWebNewsletter
import PostgresKit
import ServerDatabase
import ServerDependencies
import ServerModels
import ServerRouter

extension BlogKey: @retroactive DependencyKey {
    public static let liveValue: CoenttbWebBlog.Client = .init(
        getAll: {
            @Dependency(\.envVars.appEnv) var appEnv
            @Dependency(\.date.now) var now
            
            return [CoenttbWebBlog.Blog.Post].all
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
        @Dependency(\.request!.db) var database
        return .live(database: database)
    }()
}

extension PreviewPostKey: DependencyKey {
    public static let liveValue: @Sendable () -> [CoenttbWebBlog.Blog.Post] = {
        @Dependency(\.envVars.appEnv) var appEnv
        @Dependency(\.date.now) var now
        
        return [CoenttbWebBlog.Blog.Post].preview
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
    public static var liveValue:
    EventLoopGroupConnectionPool<PostgresConnectionSource> {
        @Dependency(\.mainEventLoopGroup) var mainEventLoopGroup
        @Dependency(\.sqlConfiguration) var sqlConfiguration
        
        return .init(
            source: PostgresConnectionSource(
                sqlConfiguration: sqlConfiguration),
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
        
        return Mailgun.Client(
            baseUrl: .init(string: baseUrl) ?? .mailgun_eu_baseUrl,
            apiKey: apiKey,
            appSecret: envVars.appSecret,
            domain: domain
        )
    }
}

extension StripeClientKey: @retroactive DependencyKey {
    public static var liveValue: CoenttbWebStripe.Client? {
        @Dependency(\.envVars) var envVars
        @Dependency(\.httpClient) var httpClient
        
        guard
            let stripeSecretKey = envVars.stripe?.secretKey
        else {
            return nil
        }
        
        return CoenttbWebStripe.Client.live(
            stripeSecretKey: stripeSecretKey,
            httpClient: httpClient
        )
    }
}

extension GitHub.Client: @retroactive DependencyKey {
    public static var liveValue: GitHub.Client? {
        @Dependency(\.envVars) var envVars
        
        guard
            let clientId = envVars.gitHub?.clientId,
            let clientSecret = envVars.gitHub?.clientSecret
        else {
            return nil
        }
        
        return GitHub.Client(
            clientId: clientId,
            clientSecret: clientSecret
        )
    }
}
