//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 25/08/2024.
//

import CoenttbVapor
import CoenttbWebModels
@preconcurrency import CoenttbStripe
import Dependencies
import EmailAddress
import Foundation
import MemberwiseInit
import Tagged

@MemberwiseInit(.package)
package struct User: Codable, Hashable, Sendable {
    package typealias ID = Tagged<Self, UUID>
    @Init(default: nil) package var id: ID?
    @Init(default: nil) package var email: EmailAddress?
    @Init(default: nil) package var name: String?
    @Init(default: false) package var authenticated: Bool
    @Init(default: nil) package var isAdmin: Bool?
    @Init(default: nil) package var isEmailVerified: Bool?
    @Init(default: nil) package var dateOfBirth: Date?
    @Init(default: nil) package var newsletterSubscribed: Bool?
    @Init(default: nil) package var stripe: User.Stripe?

    package enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case authenticated
        case isAdmin = "is_admin"
        case isEmailVerified = "is_email_verified"
        case dateOfBirth = "date_of_birth"
        case newsletterSubscribed = "newsletter_consent"
        case stripe = "stripe"
    }

    package struct Stripe: Sendable, Codable, Hashable, Content {
        package var customerId: String

        package typealias SubscriptionStatus = StripeKit.SubscriptionStatus
        package var subscriptionStatus: SubscriptionStatus?

        package enum CodingKeys: String, CodingKey {
            case customerId = "customer_id"
            case subscriptionStatus = "subscription_status"
        }

        package init(customerId: String, subscriptionStatus: SubscriptionStatus? = nil) {
            self.customerId = customerId
            self.subscriptionStatus = subscriptionStatus
        }
    }
}

extension User.Stripe.SubscriptionStatus: @retroactive @unchecked Sendable {}

extension User {
    package var accessToBlog: Bool {
        switch self.stripe?.subscriptionStatus {
        case .trialing, .pastDue, .active:  true
        case .none, .canceled, .unpaid, .incomplete, .incompleteExpired, .paused:  false
        }
    }
}
extension User {
    package var age: Int? {
        guard let dateOfBirth = dateOfBirth else { return nil }
        @Dependency(\.calendar) var calendar
        return calendar.dateComponents([.year], from: dateOfBirth, to: Date()).year
    }

    package var isAdult: Bool? {
        guard let age = age else { return nil }
        return age >= 18
    }

    package func withoutSensitiveInfo() -> Self {
        var dto = self
        dto.dateOfBirth = nil
        return dto
    }
}

extension String {
    package static let newsletterSubscribed: String = "coenttb_newsletter_subscribed"
}
