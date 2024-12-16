//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 11/09/2024.
//

import Coenttb
import CoenttbMarkdown
import CoenttbWebAccount
import CoenttbWebHTML
import Dependencies
import EnvVars
import Foundation
import Languages
import ServerDatabase
import ServerDependencies
import ServerModels
import ServerRouter
import Vapor

extension WebsitePage.Account {
    static func response(
        account: WebsitePage.Account
    ) async throws -> any AsyncResponseEncodable {
        @Dependency(\.serverRouter) var serverRouter
        switch account {
        case .index:
            throw Abort(.internalServerError)
        case let .settings(settings):
            return try await VaporApp.settings(
                settings: settings,
                create_customer_portal_session_return_url: serverRouter.url(for: .account(.settings(.index)))
            )
        case .create, .delete, .login, .logout, .password, .emailChange:
            guard let route = CoenttbWebAccount.Route(account) else { throw Abort(.internalServerError) }

            @Dependency(\.database.account) var accountDependency
            @Dependency(\.envVars.canonicalHost) var canonicalHost

            return try await CoenttbWebAccount.Route.response(
                route: route,
                logo: .coenttb,
                canonicalHref: URL(string: "\(canonicalHost ?? "localhost:8080")\(serverRouter.url(for: .account(account)).relativeString)")!,
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

extension CoenttbWebAccount.Logo {
    nonisolated(unsafe)
    static let coenttb: Self = CoenttbWebAccount.Logo(
        logo: .coenttb(),
        logoHref: {
            @Dependency(\.serverRouter) var serverRouter
            return serverRouter.url(for: .home)
        }()
    )
}
