//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/10/2024.
//

import CoenttbWebAccount
import CoenttbWebDatabase
import CoenttbWebNewsletter
import CoenttbWebStripe
import EmailAddress
import ServerModels
import StripeKit

extension ServerDatabase.Client.Stripe {
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

                @Dependency(\.request!.db) var database

                do {
                    guard let user: ServerDatabase.User = try await ServerDatabase.User.query(on: database)
                        .filter(\.$stripe.$customerId == stripeCustomerId)
                        .with(\.$identity)
                        .first()
                    else { return nil }

                    user.stripe.customerId = nil
                    try await user.save(on: database)

                    return .init(user.identity, user: user)
                } catch {
                    throw Abort(.internalServerError, reason: "Failed to delete Stripe Customer ID: \(error.localizedDescription)")
                }
            }
        )
    }
}
