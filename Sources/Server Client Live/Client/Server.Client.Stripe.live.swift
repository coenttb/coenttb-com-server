//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/10/2024.
//

import CoenttbWeb
import CoenttbIdentity
import CoenttbNewsletter
import CoenttbStripe
import Server_Models
import StripeKit
import Server_Client
import Server_Database

extension Server_Client.Client.Stripe {
    static func live(
        stripeClient: StripeKit.StripeClient
    ) -> Self {
        return .init(
            readSubscriptionStatus: { (stripeCustomerId: String) in
                let customer = try await stripeClient.customers.retrieve(customer: stripeCustomerId, expand: ["subscriptions"])
                guard let subscriptions = customer.subscriptions,
                      let firstSubscription = subscriptions.data?.first else {
                    return .none
                }

                return firstSubscription.status
            },
            delete: { (stripeCustomerId: String) in

                @Dependency(\.request?.db) var database

                do {
                    guard
                        let database,
                        let user: Server_Database.User = try await Server_Database.User.query(on: database)
                        .filter(\.$stripe.$customerId == stripeCustomerId)
                        .with(\.$identity)
                        .first()
                    else { return nil }

                    user.stripe.customerId = nil
                    try await user.save(on: database)

                    return try .init(user.identity, user: user)
                } catch {
                    throw Abort(.internalServerError, reason: "Failed to delete Stripe Customer ID: \(error.localizedDescription)")
                }
            }
        )
    }
}