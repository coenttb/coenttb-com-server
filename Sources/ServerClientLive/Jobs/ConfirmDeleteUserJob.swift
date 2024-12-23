//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 23/12/2024.
//

import ServerDatabase
import CoenttbWeb
import Queues

public struct ConfirmDeleteUserJob: AsyncScheduledJob {

    @Dependency(\.logger) var logger

    public init() {}

    typealias Payload = String

    public func run(context: QueueContext) async throws {
        let db = context.application.db
        let currentTime = Date.now
        let gracePeriodDuration: TimeInterval = 7 * 24 * 60 * 60 // 7 days

        let usersPendingDeletion = try await ServerDatabase.User.query(on: db)
            .filter(\.$deletionState == .pending)
            .all()

        for user in usersPendingDeletion {
            if let requestedAt = user.deletionRequestedAt {
                let elapsedTime = currentTime.timeIntervalSince(requestedAt)

                if elapsedTime >= gracePeriodDuration {
                    user.deletionState = .deleted
                    user.deletionRequestedAt = nil
                    try await user.save(on: db)

                    logger.info("ServerDatabase.User \(user.id?.uuidString ?? "unknown") has been permanently deleted.")
                } else {
                    logger.info("ServerDatabase.User \(user.id?.uuidString ?? "unknown") is still within the grace period.")
                }
            }
        }
    }
}


