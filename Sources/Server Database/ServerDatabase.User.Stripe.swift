//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/09/2024.
//

import Fluent
import Foundation

extension Server_Database.User {
    package final class Stripe: Fields, @unchecked Sendable {
        @Field(key: FieldKeys.customerId)
        package var customerId: String?

        @Group(key: FieldKeys.subscription)
        package var subscription: Subscription

        enum FieldKeys {
            static let customerId: FieldKey = "customer_id"
            static let subscription: FieldKey = "subscription"
        }

        package init() {}

        package final class Subscription: Fields, @unchecked Sendable {
            @Field(key: FieldKeys.id)
            package var id: String?

            @Field(key: FieldKeys.status)
            package var status: User.Stripe.Subscription.Status?

            @Field(key: FieldKeys.currentPeriodEnd)
            package var currentPeriodEnd: Date?

            @Field(key: FieldKeys.paymentMethodId)
            package var paymentMethodId: String?

            @Field(key: FieldKeys.plan)
            package var plan: String?

            enum FieldKeys {
                static let id: FieldKey = "id"
                static let status: FieldKey = "status"
                static let currentPeriodEnd: FieldKey = "current_period_end"
                static let paymentMethodId: FieldKey = "payment_method_id"
                static let plan: FieldKey = "plan"
            }

            package init() {}

            package enum Status: String, Codable, Hashable, Sendable {
                case trialing
                case pastDue
                case active
                case canceled
                case unpaid
                case incomplete
                case incompleteExpired
                case paused
            }
        }
    }
}
