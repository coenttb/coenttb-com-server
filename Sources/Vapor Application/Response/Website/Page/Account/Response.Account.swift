//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 11/09/2024.
//

import Coenttb_Identity
import Coenttb_Identity_Live
import Coenttb_Vapor
import Coenttb
import Server_EnvVars
import Server_Client
import Server_Dependencies
import Server_Models
import Server_Router

extension WebsitePage.Account {
    static func response(
        account: WebsitePage.Account
    ) async throws -> any AsyncResponseEncodable {
        @Dependency(\.serverRouter) var serverRouter
        switch account {
        case .index:
            throw Abort(.internalServerError)
        case let .settings(settings):
            return try await Vapor_Application.settings(
                settings: settings,
                create_customer_portal_session_return_url: serverRouter.url(for: .account(.settings(.index)))
            )
        case .create, .delete, .login, .logout, .password, .emailChange:
            guard let route = Coenttb_Identity.Route(account) else { throw Abort(.internalServerError) }

            @Dependency(\.serverClient.account) var accountDependency
            @Dependency(\.envVars.canonicalHost) var canonicalHost

            return try await Coenttb_Identity.Route.response(
                route: route,
                logo: .coenttb,
                canonicalHref: serverRouter.url(for: .account(account)),
                favicons: .coenttb,
                hreflang: { _, language in serverRouter.url(for: .init(language: language, page: .account(account))) },
                termsOfUse: serverRouter.url(for: .terms_of_use),
                privacyStatement: serverRouter.url(for: .privacy_statement),
                dependency: accountDependency,
                primaryColor: .coenttbPrimaryColor,
                accentColor: .coenttbAccentColor,
                homeHref: serverRouter.url(for: .home),
                loginHref: serverRouter.url(for: .account(.login)),
                accountCreateHref: serverRouter.url(for: .account(.create(.request))),
                createFormAction: serverRouter.url(for: .api(.v1(.account(.create(.request(.init())))))),
                verificationAction: serverRouter.url(for: .api(.v1(.account(.create(.verify(.init())))))),
                verificationSuccessRedirect: serverRouter.url(for: .account(.login)),
                passwordResetHref: serverRouter.url(for: .account(.password(.reset(.request)))),
                loginFormAction: serverRouter.url(for: .api(.v1(.account(.login(.init()))))),
                logout: { try await accountDependency.logout() },
                passwordChangeRequestAction: serverRouter.url(for: .api(.v1(.account(.password(.change(.request(change: .init()))))))),
                passwordResetAction: serverRouter.url(for: .api(.v1(.account(.password(.reset(.request(.init()))))))),
                passwordResetConfirmAction: serverRouter.url(for: .api(.v1(.account(.password(.reset(.confirm(.init()))))))),
                passwordResetSuccessRedirect: serverRouter.url(for: .account(.login)),
                currentUserName: {
                    @Dependency(\.currentUser?.name) var name
                    return name
                },
                currentUserIsAuthenticated: {
                    @Dependency(\.currentUser?.authenticated) var authenticated
                    return authenticated
                },
                emailChangeReauthorizationAction: serverRouter.url(for: .api(.v1(.account(.emailChange(.reauthorization(.init())))))),
                emailChangeReauthorizationSuccessRedirect: serverRouter.url(for: .account(.emailChange(.request))),
                requestEmailChangeAction: serverRouter.url(for: .api(.v1(.account(.emailChange(.request(.init())))))),
                confirmEmailChangeSuccessRedirect: serverRouter.url(for: .account(.login))
            )
        }
    }
}

extension Coenttb_Identity.Logo {
    nonisolated(unsafe)
    static let coenttb: Self = Coenttb_Identity.Logo(
        logo: .coenttb(),
        logoHref: {
            @Dependency(\.serverRouter) var serverRouter
            return serverRouter.url(for: .home)
        }()
    )
}
