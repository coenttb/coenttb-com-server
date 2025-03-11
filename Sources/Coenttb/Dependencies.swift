//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 04-01-2024.
//

import Coenttb_Server
import Coenttb_Blog
import Coenttb_Newsletter
import Coenttb_Newsletter_Live
import Mailgun
import Server_Client
import Server_Dependencies
import Server_Models
import Coenttb_Com_Shared
import Coenttb_Identity_Consumer

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Server_Client.Client {
    package static func live(
    ) -> Self {
        return .init(
            newsletter: .liveValue,
            identity: .live(),
            user: .init()
        )
    }
}

extension Coenttb_Newsletter.Client {
    package static func sendVerificationEmail(email: EmailAddress, token: String) async throws -> Messages.Send.Response {
        @Dependencies.Dependency(\.mailgunClient!.messages.send) var sendEmail
        @Dependencies.Dependency(\.fireAndForget) var fireAndForget
        @Dependencies.Dependency(\.coenttb.website.router) var router
        @Dependencies.Dependency(\.envVars.companyName!) var businessName
        @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var supportEmail
        @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var fromEmail
        
        return try await sendEmail(
            .requestEmailVerification(
                verificationUrl: router.url(for: .page(.newsletter(.subscribe(.verify(.init(token: token, email: email)))))),
                businessName: "\(businessName)",
                supportEmail: supportEmail,
                from: fromEmail,
                to: email,
                primaryColor: .green550.withDarkColor(.green600)
            )
        )
    }
}


extension Identity.Consumer.Configuration: @retroactive DependencyKey {
    public static var liveValue: Self {
        @Dependency(\.coenttb.website) var consumer
        @Dependency(\.coenttb.identity.provider) var provider
        @Dependency(\.coenttb.website.router) var router
        @Dependency(\.serverClient) var serverClient
        @Dependency(\.envVars.appEnv) var appEnv
                
        return .init(
            provider: .init(
                baseURL: provider.baseURL,
                domain: provider.baseURL.host(),
                router: provider.router
            ),
            consumer: .init(
                baseURL: consumer.baseURL,
                domain: consumer.baseURL.host(),
                cookies: .live(router.identity.eraseToAnyParserPrinter(), domain: consumer.baseURL.host()),
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

extension Newsletter: @retroactive DependencyKey {
    static public var liveValue: Self {
        @Dependency(\.coenttb.website.router) var router

        return .init(
            client: .liveValue,
            configuration: .init(
                saveToLocalstorage: true,
                cookieId: { "String.newsletterSubscribed" },
                subscribeAction: { router.url(for: .api(.newsletter(.subscribe(.request(.init()))))) },
                subscribeCaption: { String.subscribe_to_my_newsletter.capitalizingFirstLetter().description },
                subscribeFormId: { "coenttb-web-newsletter-route-subscribe-view" },
                subscribeOverlayId: { "newsletter-overlay-id"},
                unsubscribeAction: { router.url(for: .api(.newsletter(.unsubscribe(.init())))) },
                unsubscribeFormId: { "coenttb-web-newsletter-route-unsubscribe-view" },
                verificationAction: { verify in router.url(for: .api(.newsletter(.subscribe(.verify(.init(token: verify.token, email: verify.email)))))) },
                verificationRedirectURL: { router.url(for: .home) }
            )
        )
    }
}

extension Coenttb_Newsletter.Client: @retroactive DependencyKey {
    public static var liveValue: Self {
        Coenttb_Newsletter.Client.live(
            sendVerificationEmail: Coenttb_Newsletter.Client.sendVerificationEmail,
            onSuccessfullyVerified: { email in
                @Dependency(\.mailgunClient) var mailgunClient
                @Dependency(\.envVars.newsletterAddress) var listAddress
                @Dependency(\.logger ) var logger
                
                guard
                    let listAddress,
                    let response = try await mailgunClient?.mailingLists.addMember(
                    listAddress: listAddress,
                    request: .init(
                        address: email
                    )
                )
                else {
                    return
                }
                
                logger.info("\(response)")
                
                @Dependency(\.envVars.appEnv) var appEnv
                @Dependency(\.envVars.mailgun?.domain) var domain
                @Dependency(\.envVars.mailgunCompanyEmail) var mailgunCompanyEmail
                @Dependency(\.envVars.companyName) var companyName
                @Dependency(\.envVars) var envVars
                
                guard
                    let mailgunCompanyEmail,
                    let companyName
                else { return  }
                
                guard let send = mailgunClient?.messages.send
                else { return }

                let response2 = try await send(
                    Email.notifyOfNewSubscription(
                        from: mailgunCompanyEmail,
                        to: mailgunCompanyEmail,
                        subscriberEmail: email,
                        companyEmail: mailgunCompanyEmail,
                        companyName: companyName
                    )
                )
                
                logger.info("\(response2)")
            },
            onUnsubscribed: { email in
                @Dependency(\.mailgunClient) var mailgunClient
                @Dependency(\.envVars.newsletterAddress) var listAddress
                @Dependency(\.logger) var logger
                
                guard
                    let listAddress,
                    let response = try await mailgunClient?.mailingLists.deleteMember(listAddress: listAddress, memberAddress: email)
                else {
                    return
                }
                
                logger.info("\(response)")
            }
        )
    }
}




extension LanguagesKey: @retroactive DependencyKey {
    public static var liveValue: Set<Language> {
        @Dependency(\.envVars.languages) var languages
        return languages.map(Set.init) ?? .allCases
    }
}

extension Server_Client.Client: DependencyKey {
    package static var liveValue: Server_Client.Client {
        return .live()
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
