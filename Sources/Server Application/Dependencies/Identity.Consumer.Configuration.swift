//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 12/03/2025.
//

import Coenttb_Server
import Dependencies
import Coenttb_Blog
import Mailgun
import Server_Client
import Server_Dependencies
import Server_Models
import Coenttb_Com_Shared
import Coenttb_Identity_Consumer

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Identity.Consumer.Configuration: @retroactive DependencyKey {
    public static var liveValue: Self {
        fatalError()
//        @Dependency(\.coenttb.website) var consumer
//        @Dependency(\.coenttb.identity.provider) var provider
//        @Dependency(\.coenttb.website.router) var router
//        @Dependency(\.serverClient) var serverClient
//        @Dependency(\.envVars.appEnv) var appEnv
//                
//        return .init(
//            provider: .init(
//                baseURL: provider.baseURL,
//                domain: provider.baseURL.host(),
//                router: provider.router
//            ),
//            consumer: .init(
//                baseURL: consumer.baseURL,
//                domain: consumer.baseURL.host(),
//                cookies: .live(router.identity.eraseToAnyParserPrinter(), domain: consumer.baseURL.host()),
//                router: router.identity,
//                client: serverClient.identity,
//                currentUserName: { nil },
//                hreflang: { router.url(for: .init(language: $1, page: .identity($0))) },
//                branding: .init(
//                    logo: .init(
//                        logo: .coenttb(),
//                        href: router.url(for: .home)
//                    ),
//                    primaryColor: .branding.primary,
//                    accentColor: .branding.accent,
//                    favicons: .coenttb,
//                    termsOfUse: router.url(for: .terms_of_use),
//                    privacyStatement: router.url(for: .privacy_statement)
//                ),
//                navigation: .init(
//                    home: { router.url(for: .home) }
//                ),
//                redirect: .init(
//                    createProtected: { router.url(for: .home) },
//                    loginProtected: { router.url(for: .home) },
//                    loginSuccess: { router.url(for: .account(.settings(.index))) }
//                )
//            )
//        )
    }
}
