//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 11/09/2024.
//

import Coenttb_Vapor
import Server_Application
import Server_EnvVars
import Server_Client
import Server_Dependencies
import Server_Models
import Coenttb_Com_Shared
import Coenttb_Com_Router
import Coenttb_Identity_Consumer

extension WebsitePage.Account {
    static func response(
        account: WebsitePage.Account
    ) async throws -> any AsyncResponseEncodable {
        @Dependency(\.coenttb.website.router) var serverRouter
        switch account {
        case .index:
            throw Abort(.internalServerError)
        case let .settings(settings):
            return try await Vapor_Application.settings(
                settings: settings,
                create_customer_portal_session_return_url: serverRouter.url(for: .account(.settings(.index)))
            )
        }
    }
}
