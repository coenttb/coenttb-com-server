//
//  [any Migration].swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 16/09/2024.
//

import Coenttb_Newsletter_Records
import Coenttb_Server
import Dependencies
import EmailAddress
import Fluent
import Records
import Server_EnvVars

// MARK: - Fluent Migrations (Legacy)

extension [any Fluent.Migration] {
    package static var allCases: Self {
        var migrations: [any Fluent.Migration] = [
            {
                var migration = Server_Database.User.CreateMigration()
                migration.name = "Server_Database.User.Migration.Create"
                return migration
            }()
        ]

        @Dependency(\.envVars.appEnv) var appEnv

        // TODO: Rewrite CreateUnverifiedNewsletterMigration to use Records instead of Fluent
        // if appEnv == .development {
        //     migrations.append(CreateUnverifiedNewsletterMigration())
        // }

        return migrations
    }
}

// MARK: - Records Migrations (New)

extension Records.Database.Migrator {
    package static func coenttbCom() -> Records.Database.Migrator {
        var migrator = Records.Database.Migrator()

        // Register all newsletter migrations
        for (name, statements) in NewsletterMigrations.allMigrations() {
            migrator.registerMigration(name) { db in
                for statement in statements {
                    try await db.execute(statement)
                }
            }
        }

        return migrator
    }
}

// TODO: Rewrite to use Records instead of Fluent
// package struct CreateUnverifiedNewsletterMigration: AsyncMigration {
//     package init() {}
//
//     package func prepare(on database: Database) async throws {
//         @Dependency(\.envVars) var envVars
//         @Dependency(\.logger) var logger
//
//         guard let email: EmailAddress = envVars.demoNewsletterEmail else {
//             logger.log(.warning, "Environment variable for demo newsletter email is missing.")
//             return
//         }
//
//         let newsletterSubscription = try Newsletter.Record(
//             email: email.rawValue,
//             emailVerificationStatus: .unverified
//         )
//
//         do {
//             @Dependency(\.defaultDatabase) var database
//             try await database.write { db in
//                 try await Newsletter.Record
//                     .insert { newsletterSubscription }
//                     .execute(db)
//             }
//             logger.log(.info, "Created unverified newsletter subscription for email: \(email)")
//         } catch {
//             logger.log(.error, "Failed to create unverified newsletter subscription: \(error)")
//         }
//     }
//
//     package func revert(on database: Database) async throws {
//         @Dependency(\.envVars) var envVars
//         @Dependency(\.logger) var logger
//
//         guard let email: EmailAddress = envVars.demoNewsletterEmail else {
//             logger.log(.warning, "Environment variable for demo newsletter email is missing.")
//             return
//         }
//
//         do {
//             @Dependency(\.defaultDatabase) var database
//             try await database.write { db in
//                 try await Newsletter.Record
//                     .delete()
//                     .where { $0.email.eq(email.rawValue) }
//                     .execute(db)
//             }
//             logger.log(.info, "Deleted unverified newsletter subscription for email: \(email)")
//         } catch {
//             logger.log(.error, "Failed to delete unverified newsletter subscription: \(error)")
//         }
//     }
// }
