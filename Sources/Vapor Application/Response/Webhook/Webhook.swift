//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 17-12-2023.
//

import Coenttb_Vapor
import Dependencies
import Fluent
import Foundation
import Languages
import Mailgun
import Prelude
import Server_Dependencies
import Coenttb_Com_Shared
import Coenttb_Com_Router
//import Coenttb_Stripe

extension Coenttb_Com_Router.Route.Webhook {
    static func response(
        webhook: Coenttb_Com_Router.Route.Webhook
    ) async throws -> any AsyncResponseEncodable {
        switch webhook {
        case .mailgun:
            @Dependency(\.request) var request
            guard let request else { return Response.internalServerError }
            return try await Mailgun.Client.webhook(request: request)

//        case .stripe:
//            @Dependency(\.request) var request
//            guard let request else { return Response.internalServerError }
//            return try await Coenttb_Stripe.Client.webhook(request: request)
        }
    }
}
