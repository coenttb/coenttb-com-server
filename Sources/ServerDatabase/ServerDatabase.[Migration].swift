//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/09/2024.
//

import CoenttbVapor
import CoenttbWebAccount
import CoenttbWebModels
import CoenttbWebNewsletter
import CoenttbWebStripe
import Dependencies
import Fluent
import Foundation

extension [any Fluent.Migration] {
    public static var coenttb: Self {
        var migrations: [any Fluent.Migration] = [
            CoenttbWebAccount.Identity.Migration(),
            CoenttbWebAccount.Identity.Token.Migration(),
            CoenttbWebAccount.EmailChangeRequest.Migration(),
            ServerDatabase.User.CreateMigration(),
            CoenttbWebNewsletter.CreateNewsletter()
        ]

    #if DEBUG
        migrations.append(CreateDemoUserMigration())
    #endif

        return migrations
    }
}

public struct CreateDemoUserMigration: AsyncMigration {
    public init() {}

    public func prepare(on database: Database) async throws {

        @Dependency(\.envVars) var envVars
        @Dependency(\.logger) var logger

        guard
            let email: String = envVars.demoEmail,
            let name: String = envVars.demoName,
            let password: String = envVars.demoPassword,
            let stripeCustomerId: String = envVars.demoStripeCustomerId
        else { return }

        let identity = try Identity(
            email: email,
            password: password,
            name: name,
            isAdmin: false,
            emailVerificationStatus: .verified
        )

        try await identity.save(on: database)

        let user = ServerDatabase.User(
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
                email: email
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

    public func revert(on database: Database) async throws {

        @Dependency(\.envVars) var envVars

        guard
            let email: String = envVars.demoEmail
        else { return }

        guard let identity = try await Identity.query(on: database)
            .filter(\.$email == email)
            .first() else {
            return
        }

        try await ServerDatabase.User.query(on: database)
            .filter(\.$identity.$id == identity.id!)
            .delete()

        try await identity.delete(on: database)
    }
}
