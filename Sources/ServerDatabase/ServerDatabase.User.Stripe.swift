//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/09/2024.
//

import Fluent
@preconcurrency import CoenttbStripe
import Foundation

extension ServerDatabase.User {
    public final class Stripe: Fields, @unchecked Sendable {
        @Field(key: FieldKeys.customerId)
        public var customerId: String?

        @Group(key: FieldKeys.subscription)
        public var subscription: Subscription

        enum FieldKeys {
            static let customerId: FieldKey = "customer_id"
            static let subscription: FieldKey = "subscription"
        }

        public init() {}

        public final class Subscription: Fields, @unchecked Sendable {
            @Field(key: FieldKeys.id)
            public var id: String?

            @Field(key: FieldKeys.status)
            public var status: User.Stripe.Subscription.Status?

            @Field(key: FieldKeys.currentPeriodEnd)
            public var currentPeriodEnd: Date?

            @Field(key: FieldKeys.paymentMethodId)
            public var paymentMethodId: String?

            @Field(key: FieldKeys.plan)
            public var plan: String?

            enum FieldKeys {
                static let id: FieldKey = "id"
                static let status: FieldKey = "status"
                static let currentPeriodEnd: FieldKey = "current_period_end"
                static let paymentMethodId: FieldKey = "payment_method_id"
                static let plan: FieldKey = "plan"
            }

            public init() {}

            public typealias Status = StripeKit.SubscriptionStatus
        }
    }
}

extension StripeKit.SubscriptionStatus: @unchecked @retroactive Sendable {}
