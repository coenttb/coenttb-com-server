//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 17-12-2023.
//

import Coenttb_Vapor
import Mailgun
import Server_Dependencies

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
