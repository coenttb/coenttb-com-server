//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 04-01-2024.
//

import Coenttb_Server
import Coenttb_Blog
import Coenttb_Newsletter
import Mailgun
import Server_Client
import Server_Client_Live
import Server_Dependencies
import Server_Models
import Server_Router
import Authenticated
//import Coenttb_Stripe
//import Coenttb_Stripe_Live


#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension BlogKey: @retroactive DependencyKey {
    public static let liveValue: Coenttb_Blog.Client = .init(
        getAll: {
            @Dependency(\.envVars.appEnv) var appEnv
            @Dependency(\.date.now) var now
            
            return [Coenttb_Blog.Blog.Post].allCases
                .filter {
                    appEnv == .production
                    ? $0.publishedAt <= now
                    : true
                }
        },
        filenameToResourceUrl: { fileName in
            return Bundle.module.url(forResource: fileName, withExtension: "md")
        },
        postToRoute: { post in
            @Dependency(\.serverRouter) var serverRouter
            return serverRouter.url(for: .blog(.post(post)))
        },
        postToFilename: { post in
            return .init { language in
                [
                    post.category.map{ $0(language) },
                    "\(post.index)",
                    language.rawValue
                ]
                    .compactMap{ $0 }
                    .joined(separator: "-")
            }
        }
    )
}

extension LanguagesKey: @retroactive DependencyKey {
    public static let liveValue: Set<Language> = {
        @Dependency(\.envVars.languages) var languages
        return languages.map(Set.init) ?? .allCases
    }()
}

extension DatabaseClientKey: DependencyKey {
    package static let liveValue: Server_Client.Client = {
        @Dependency(\.request?.db) var database
        
        guard
            let database
        else {
            return Server_Client.Client.previewValue
        }
        
        return .live(database: database)
    }()
}

extension CurrentUserKey: DependencyKey {
    package static let liveValue: User? = nil
}

extension Server_RouterKey: DependencyKey {
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

extension ProjectRootKey: @retroactive DependencyKey {
    public static var liveValue: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
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
    public static let liveValue: Logger = {
        @Dependency(\.envVars) var envVars
        var logger = Logger(label: ProcessInfo.processInfo.processName) { _ in
            CoenttbLogHandler(label: "coenttb", logLevel: envVars.logLevel ?? .trace, metadataProvider: nil)
        }
        return logger
    }()
}

extension Mailgun.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.AuthenticatedClient? {
        @Dependency(\.envVars) var envVars
        
        guard
            let baseURL = envVars.mailgun?.baseURL,
            let apiKey = envVars.mailgun?.apiKey,
            let domain = envVars.mailgun?.domain
        else {
            return nil
        }
        
        return Mailgun.Client.live(
            apiKey: apiKey,
            baseUrl: baseURL,
            domain: domain,
            session: { try await URLSession.shared.data(for: $0) }
        )
    }
}

//extension StripeClientKey: @retroactive DependencyKey {
//    public static var liveValue: Coenttb_Stripe.Client? {
//        @Dependency(\.envVars) var envVars
//        @Dependency(\.httpClient) var httpClient
//        
//        guard
//            let stripeSecretKey = envVars.stripe?.secretKey
//        else {
//            return nil
//        }
//        
//        return Coenttb_Stripe.Client.live(
//            stripeSecretKey: stripeSecretKey,
//            httpClient: httpClient
//        )
//    }
//}

extension DatabaseConfigurationKey: @retroactive DependencyKey {
    public static let liveValue = DatabaseConfiguration(
        maxConnectionsPerEventLoop: 1,
        connectionPoolTimeout: .seconds(10)
    )
}
