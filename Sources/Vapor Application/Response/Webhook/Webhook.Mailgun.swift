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
import Vapor

extension Mailgun.Client {
    static func webhook(
        request: Vapor.Request
    ) async throws -> any AsyncResponseEncodable {

#if DEBUG
        @Dependency(\.logger) var logger: Logger
        logger.log(.info, "Mailgun.Client.webhook called")
#endif

        return Response.ok
    }
}
