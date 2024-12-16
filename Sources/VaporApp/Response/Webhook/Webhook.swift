//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 17-12-2023.
//

import CoenttbWebHTML
import CoenttbWebStripe
import Dependencies
import Fluent
import Foundation
import HttpPipeline
import Languages
import Mailgun
import Prelude
import ServerDependencies
import ServerRouter
import Vapor

extension Webhook {
    static func response(
        webhook: Webhook
    ) async throws -> any AsyncResponseEncodable {
        switch webhook {
        case .mailgun:
            @Dependency(\.request) var request
            guard let request else { return Response.internalServerError }
            return try await Mailgun.Client.webhook(request: request)

        case .stripe:
            @Dependency(\.request) var request
            guard let request else { return Response.internalServerError }
            return try await CoenttbWebStripe.Client.webhook(request: request)
        }
    }
}
