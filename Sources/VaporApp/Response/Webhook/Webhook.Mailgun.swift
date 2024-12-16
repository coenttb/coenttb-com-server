//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 17-12-2023.
//

import CoenttbWebHTML
import Dependencies
import Fluent
import Foundation
import HttpPipeline
import Languages
import Mailgun
import Prelude
import ServerDependencies
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
