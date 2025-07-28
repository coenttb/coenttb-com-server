//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/09/2024.
//

import Coenttb_Newsletter_Fluent
import Coenttb_Server
import Fluent
import Server_EnvVars
import EmailAddress

extension [any Fluent.Migration] {
    package static var allCases: Self {
        var migrations: [any Fluent.Migration] = [
            {
                var migration = Server_Database.User.CreateMigration()
                migration.name = "Server_Database.User.Migration.Create"
                return migration
            }(),
            {
                var migration = Newsletter.Migration.Create()
                migration.name = "Coenttb_Newsletter.Newsletter.Migration.Create"
                return migration
            }(),
            {
                var migration = Coenttb_Newsletter_Fluent.Newsletter.Token.Migration.Create()
                migration.name = "Coenttb_Newsletter.Newsletter.Token.Migration.Create"
                return migration
            }(),
            {
                var migration = Coenttb_Newsletter_Fluent.Newsletter.Migration.STEP_1_AddUpdatedAt()
                migration.name = "Coenttb_Newsletter.Newsletter.Migration.STEP_1_AddUpdatedAt"
                return migration
            }(),
            {
                var migration = Coenttb_Newsletter_Fluent.Newsletter.Migration.STEP_2_AddEmailVerification()
                migration.name = "Coenttb_Newsletter.Newsletter.Migration.STEP_2_AddEmailVerification"
                return migration
            }(),
            {
                var migration = Coenttb_Newsletter_Fluent.Newsletter.Migration.STEP_3_AddLastEmailMessageId()
                migration.name = "Coenttb_Newsletter.Newsletter.Migration.STEP_3_AddLastEmailMessageId"
                return migration
            }()
        ]

#if DEBUG && os(macOS)
        migrations.append(CreateUnverifiedNewsletterMigration())
#endif

        return migrations
    }
}

package struct CreateUnverifiedNewsletterMigration: AsyncMigration {
    package init() {}

    package func prepare(on database: Database) async throws {
        @Dependency(\.envVars) var envVars
        @Dependency(\.logger) var logger

        guard let email: EmailAddress = envVars.demoNewsletterEmail else {
            logger.log(.warning, "Environment variable for demo newsletter email is missing.")
            return
        }

        let newsletterSubscription = try Newsletter(
            email: email.rawValue,
            emailVerificationStatus: .unverified
        )

        do {
            try await newsletterSubscription.save(on: database)
            logger.log(.info, "Created unverified newsletter subscription for email: \(email)")
        } catch {
            logger.log(.error, "Failed to create unverified newsletter subscription: \(error)")
        }
    }

    package func revert(on database: Database) async throws {
        @Dependency(\.envVars) var envVars
        @Dependency(\.logger) var logger

        guard let email: EmailAddress = envVars.demoNewsletterEmail else {
            logger.log(.warning, "Environment variable for demo newsletter email is missing.")
            return
        }

        do {
            try await Newsletter.query(on: database)
                .filter(\.$email == email.rawValue)
                .delete()
            logger.log(.info, "Deleted unverified newsletter subscription for email: \(email)")
        } catch {
            logger.log(.error, "Failed to delete unverified newsletter subscription: \(error)")
        }
    }
}
