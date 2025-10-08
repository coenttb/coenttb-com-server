//
//  File.swift
//  rule-law-server
//
//  Created by Coen ten Thije Boonkkamp on 25/08/2024.
//

import Dependencies
import EmailAddress
import Foundation

public struct User: Codable, Hashable, Sendable, Identifiable {
    public typealias ID = UUID
    public var id: ID
    public var email: EmailAddress?
    public var name: String?
    public var authenticated: Bool
    public var isAdmin: Bool?
    public var isEmailVerified: Bool?
    public var dateOfBirth: Date?
    public var newsletterSubscribed: Bool?
    public var stripe: User.Stripe?

    public init(
        id: ID,
        email: EmailAddress? = nil,
        name: String? = nil,
        authenticated: Bool = false,
        isAdmin: Bool? = nil,
        isEmailVerified: Bool? = nil,
        dateOfBirth: Date? = nil,
        newsletterSubscribed: Bool? = nil,
        stripe: User.Stripe? = nil
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.authenticated = authenticated
        self.isAdmin = isAdmin
        self.isEmailVerified = isEmailVerified
        self.dateOfBirth = dateOfBirth
        self.newsletterSubscribed = newsletterSubscribed
        self.stripe = stripe
    }

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

    public struct Stripe: Sendable, Codable, Hashable {
        public var customerId: String

//        public typealias SubscriptionStatus = StripeKit.SubscriptionStatus
        public enum SubscriptionStatus: String, Codable, Hashable, Sendable {
            case trialing
            case pastDue
            case active
            case canceled
            case unpaid
            case incomplete
            case incompleteExpired
            case paused
        }
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
