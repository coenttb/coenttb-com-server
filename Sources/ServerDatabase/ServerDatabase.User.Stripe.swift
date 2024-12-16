//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/09/2024.
//

import CoenttbWebAccount
import CoenttbWebModels
@preconcurrency import CoenttbWebStripe
import EmailAddress
import Fluent
import Foundation
import MemberwiseInit
import Tagged

extension ServerDatabase.User {
    final class Stripe: Fields, @unchecked Sendable {
        @Field(key: FieldKeys.customerId)
        var customerId: String?

        @Group(key: FieldKeys.subscription)
        var subscription: Subscription

        enum FieldKeys {
            static let customerId: FieldKey = "customer_id"
            static let subscription: FieldKey = "subscription"
        }

        init() {}

        final class Subscription: Fields, @unchecked Sendable {
            @Field(key: FieldKeys.id)
            var id: String?

            @Field(key: FieldKeys.status)
            var status: User.Stripe.Subscription.Status?

            @Field(key: FieldKeys.currentPeriodEnd)
            var currentPeriodEnd: Date?

            @Field(key: FieldKeys.paymentMethodId)
            var paymentMethodId: String?

            @Field(key: FieldKeys.plan)
            var plan: String?

            enum FieldKeys {
                static let id: FieldKey = "id"
                static let status: FieldKey = "status"
                static let currentPeriodEnd: FieldKey = "current_period_end"
                static let paymentMethodId: FieldKey = "payment_method_id"
                static let plan: FieldKey = "plan"
            }

            init() {}

            public typealias Status = StripeKit.SubscriptionStatus
        }
    }
}

extension StripeKit.SubscriptionStatus: @unchecked @retroactive Sendable {}
