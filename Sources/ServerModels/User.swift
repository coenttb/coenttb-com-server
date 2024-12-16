//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 25/08/2024.
//

import CoenttbVapor
import CoenttbWebModels
@preconcurrency import CoenttbWebStripe
import Dependencies
import EmailAddress
import Foundation
import MemberwiseInit
import Tagged

@MemberwiseInit(.public)
public struct User: Codable, Hashable, Sendable {
    public typealias ID = Tagged<Self, UUID>
    @Init(default: nil) public var id: ID?
    @Init(default: nil) public var email: EmailAddress?
    @Init(default: nil) public var name: String?
    @Init(default: false) public var authenticated: Bool
    @Init(default: nil) public var isAdmin: Bool?
    @Init(default: nil) public var isEmailVerified: Bool?
    @Init(default: nil) public var dateOfBirth: Date?
    @Init(default: nil) public var newsletterSubscribed: Bool?
    @Init(default: nil) public var stripe: User.Stripe?

    public enum CodingKeys: String, CodingKey {
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

    public struct Stripe: Sendable, Codable, Hashable, Content {
        public var customerId: String

        public typealias SubscriptionStatus = StripeKit.SubscriptionStatus
        public var subscriptionStatus: SubscriptionStatus?

        public enum CodingKeys: String, CodingKey {
            case customerId = "customer_id"
            case subscriptionStatus = "subscription_status"
        }

        public init(customerId: String, subscriptionStatus: SubscriptionStatus? = nil) {
            self.customerId = customerId
            self.subscriptionStatus = subscriptionStatus
        }
    }
}

extension User {
    public var accessToBlog: Bool {
        switch self.stripe?.subscriptionStatus {
        case .trialing, .pastDue, .active:  true
        case .none, .canceled, .unpaid, .incomplete, .incompleteExpired, .paused:  false
        }
    }
}
extension User {
    public var age: Int? {
        guard let dateOfBirth = dateOfBirth else { return nil }
        @Dependency(\.calendar) var calendar
        return calendar.dateComponents([.year], from: dateOfBirth, to: Date()).year
    }

    public var isAdult: Bool? {
        guard let age = age else { return nil }
        return age >= 18
    }

    public func withoutSensitiveInfo() -> Self {
        var dto = self
        dto.dateOfBirth = nil
        return dto
    }
}

extension String {
    public static let newsletterSubscribed: String = "coenttb_newsletter_subscribed"
}
