//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 12/03/2025.
//

import Coenttb_Blog
import Coenttb_Com_Shared
import Coenttb_Identity_Consumer
import Coenttb_Server
import Dependencies
import Mailgun
import Server_Client
import Server_Dependencies
import Server_Models

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

        let provider2: Identity.Consumer.Configuration.Provider = .init(
            baseURL: provider.baseURL,
            domain: provider.baseURL.host(),
            router: provider.router
        )

        let consumer2: Identity.Consumer.Configuration.Consumer = .live(
            baseURL: consumer.baseURL,
            domain: consumer.baseURL.host(),
            cookies: .live(router.identity.eraseToAnyParserPrinter(), domain: consumer.baseURL.host()),
            router: router.identity,
            client: serverClient.identity,
            currentUserName: { nil },
            canonicalHref: { router.url(for: .identity($0)) },
            hreflang: { router.url(for: .init(language: $1, page: .identity($0))) },
            branding: .init(
                logo: .init(
                    logo: .coenttb(),
                    href: router.url(for: .home)
                ),
                primaryColor: .branding.primary,
                accentColor: .branding.accent,
                favicons: .coenttb,
                termsOfUse: router.url(for: .terms_of_use),
                privacyStatement: router.url(for: .privacy_statement)
            ),
            navigation: .init(home: { router.url(for: .home) }),
            redirect: .init(
                createProtected: { router.url(for: .home) },
                createVerificationSuccess: { router.identity.url(for: .view(.login)) },
                loginProtected: { router.url(for: .home) },
                logoutSuccess: { router.identity.url(for: .view(.login)) },
                loginSuccess: { router.url(for: .home) },
                passwordResetSuccess: { router.identity.url(for: .view(.login)) },
                emailChangeConfirmSuccess: { router.identity.url(for: .view(.login)) }
            ),
            rateLimiters: .init(
                credentials: RateLimiter<String>(
                    windows: [
                        .minutes(1, maxAttempts: 10),
                        .hours(1, maxAttempts: 100)
                    ],
                    metricsCallback: { key, result async in
                        @Dependency(\.logger) var logger
                        if !result.isAllowed {
                            logger.warning("Token refresh rate limit exceeded for \(key)")
                        }
                    }
                ),
                tokenAccess: RateLimiter<String>(
                    windows: [
                        .minutes(1, maxAttempts: 10),
                        .hours(1, maxAttempts: 100)
                    ],
                    metricsCallback: { key, result async in
                        @Dependency(\.logger) var logger
                        if !result.isAllowed {
                            logger.warning("Token refresh rate limit exceeded for \(key)")
                        }
                    }
                ),
                tokenRefresh: RateLimiter<String>(
                    windows: [
                        .minutes(1, maxAttempts: 10),
                        .hours(1, maxAttempts: 100)
                    ],
                    metricsCallback: { key, result async in
                        @Dependency(\.logger) var logger
                        if !result.isAllowed {
                            logger.warning("Token refresh rate limit exceeded for \(key)")
                        }
                    }
                )
            )
        )

        let config: Identity.Consumer.Configuration = .init(
            provider: provider2,
            consumer: consumer2
        )

        return config
    }
}
