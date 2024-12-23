//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/09/2024.
//

import CoenttbWeb
import CoenttbIdentityFluent
import CoenttbNewsletterFluent
import CoenttbStripe

extension [any Fluent.Migration] {
    package static var allCases: Self {
        var migrations: [any Fluent.Migration] = [
            {
                var migration = CoenttbIdentityFluent.Identity.Migration.Create()
                migration.name = "CoenttbIdentity.Identity.Migration.Create"
                return migration
            }(),
            {
                var migration = CoenttbIdentityFluent.Identity.Token.Migration()
                migration.name = "CoenttbIdentity.Identity.Token.Migration.Create"
                return migration
            }(),
            {
                var migration = CoenttbIdentityFluent.EmailChangeRequest.Migration()
                migration.name = "CoenttbIdentity.EmailChangeRequest.Migration.Create"
                return migration
            }(),
            {
                var migration = Server_Database.User.CreateMigration()
                migration.name = "ServerDatabase.User.Migration.Create"
                return migration
            }(),
            {
                var migration = Newsletter.Migration.Create()
                migration.name = "CoenttbNewsletter.Newsletter.Migration.Create"
                return migration
            }(),
            {
                var migration = CoenttbNewsletterFluent.Newsletter.Token.Migration.Create()
                migration.name = "CoenttbNewsletter.Newsletter.Token.Migration.Create"
                return migration
            }(),
            {
                var migration = CoenttbNewsletterFluent.Newsletter.Migration.STEP_1_AddUpdatedAt()
                migration.name = "CoenttbNewsletter.Newsletter.Migration.STEP_1_AddUpdatedAt"
                return migration
            }(),
            {
                var migration = CoenttbNewsletterFluent.Newsletter.Migration.STEP_2_AddEmailVerification()
                migration.name = "CoenttbNewsletter.Newsletter.Migration.STEP_2_AddEmailVerification"
                return migration
            }(),
            {
                var migration = CoenttbNewsletterFluent.Newsletter.Migration.STEP_3_AddLastEmailMessageId()
                migration.name = "CoenttbNewsletter.Newsletter.Migration.STEP_3_AddLastEmailMessageId"
                return migration
            }(),
        ]

#if DEBUG
        migrations.append(CreateDemoUserMigration())
        migrations.append(CreateUnverifiedNewsletterMigration())
#endif

        return migrations
    }
}

package struct CreateDemoUserMigration: AsyncMigration {
    package init() {}

    package func prepare(on database: Database) async throws {

        @Dependency(\.envVars) var envVars
        @Dependency(\.logger) var logger

        guard
            let email: EmailAddress = envVars.demoEmail,
            let name: String = envVars.demoName,
            let password: String = envVars.demoPassword,
            let stripeCustomerId: String = envVars.demoStripeCustomerId
        else { return }

        let identity = try Identity(
            email: email.rawValue,
            password: password,
            name: name,
            isAdmin: false,
            emailVerificationStatus: .verified
        )

        try await identity.save(on: database)

        let user = Server_Database.User(
            identityID: try identity.requireID(),
            dateOfBirth: nil,
            newsletterConsent: true
        )

        user.stripe = .init()
        user.stripe.customerId = stripeCustomerId

        @Dependencies.Dependency(\.stripe) var stripe

        do {
            _ = try await stripe?.customers.update(
                customer: stripeCustomerId,
                email: email.address
            )
        } catch {
            logger.log(.warning, "\(error)")
            logger.log(.warning, """
            Couldn't create stripe customer.

            Most likely the customerId is wrong, or you didn't forward events to your (local) webhook. Example: stripe listen --forward-to localhost:8080/webhook/stripe
            """)
        }

        try await user.save(on: database)
    }

    package func revert(on database: Database) async throws {

        @Dependency(\.envVars) var envVars

        guard
            let email: EmailAddress = envVars.demoEmail
        else { return }

        guard let identity = try await Identity.query(on: database)
            .filter(\.$email == email.rawValue)
            .first() else {
            return
        }

        try await Server_Database.User.query(on: database)
            .filter(\.$identity.$id == identity.id!)
            .delete()

        try await identity.delete(on: database)
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
