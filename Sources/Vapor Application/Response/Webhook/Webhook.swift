//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 17-12-2023.
//

import Coenttb_Server_HTML
import Dependencies
import Fluent
import Foundation
import Languages
import Mailgun
import Prelude
import Server_Dependencies
import Server_Router
import Vapor
//import Coenttb_Stripe

extension Webhook {
    static func response(
        webhook: Webhook
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
