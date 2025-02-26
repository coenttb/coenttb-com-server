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
import Coenttb_Com_Shared
import Coenttb_Identity_Consumer

//import Coenttb_Stripe
//import Coenttb_Stripe_Live


#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Identity.Consumer.Configuration: @retroactive DependencyKey {
    public static var liveValue: Self {
        @Dependency(\.coenttb.website) var consumer
        @Dependency(\.coenttb.identity.provider) var provider
        @Dependency(\.coenttb.website.router) var router
        @Dependency(\.serverClient) var serverClient
        @Dependency(\.envVars.appEnv) var appEnv
        
        let cookies: Identity.CookiesConfiguration = switch appEnv {
        case .development, .testing: .development
        case .production, .staging: .live
        }
        
        return .init(
            provider: .init(
                baseURL: provider.baseURL,
                domain: nil,
                router: provider.router
            ),
            consumer: .init(
                baseURL: consumer.baseURL,
                domain: nil,
                cookies: cookies,
                router: router.identity,
                client: serverClient.identity,
                currentUserName: { nil },
                hreflang: { router.url(for: .init(language: $1, page: .identity($0))) },
                branding: .init(
                    logo: .init(
                        logo: .coenttb(),
                        href: router.url(for: .home)
                    ),
                    primaryColor: .coenttbPrimaryColor,
                    accentColor: .coenttbAccentColor,
                    favicons: .coenttb,
                    termsOfUse: router.url(for: .terms_of_use),
                    privacyStatement: router.url(for: .privacy_statement)
                ),
                navigation: .init(
                    home: { router.url(for: .home) }
                ),
                redirect: .init(
                    createProtected: { router.url(for: .home) },
                    loginProtected: { router.url(for: .home) },
                    loginSuccess: { router.url(for: .account(.settings(.index))) }
                )
            )
        )
    }
}

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
            @Dependency(\.coenttb.website.router) var serverRouter
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
    public static var liveValue: Set<Language> {
        @Dependency(\.envVars.languages) var languages
        return languages.map(Set.init) ?? .allCases
    }
}

extension DatabaseClientKey: DependencyKey {
    package static var liveValue: Server_Client.Client {
        @Dependency(\.request?.db) var database
        
        guard
            let database
        else {
            return Server_Client.Client.previewValue
        }
        
        return .live(database: database)
    }
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

extension Logger: @retroactive DependencyKey {
    public static var liveValue: Logger {
        @Dependency(\.envVars) var envVars
        let logger = Logger(label: ProcessInfo.processInfo.processName) { _ in
            CoenttbLogHandler(label: "coenttb.com", logLevel: envVars.logLevel ?? .trace, metadataProvider: nil)
        }
        return logger
    }
}

extension Mailgun.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.AuthenticatedClient? {
        @Dependency(\.envVars) var envVars
        
        guard
            let baseURL = envVars.mailgun?.baseUrl,
            let apiKey = envVars.mailgun?.apiKey,
            let domain = envVars.mailgun?.domain
        else {
            return nil
        }
        
        return Mailgun.Client.live(
            apiKey: apiKey,
            baseUrl: baseURL,
            domain: domain
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

//extension DatabaseConfigurationKey: @retroactive DependencyKey {
//    public static var liveValue = DatabaseConfiguration(
//        maxConnectionsPerEventLoop: 1,
//        connectionPoolTimeout: .seconds(10)
//    )
//}
