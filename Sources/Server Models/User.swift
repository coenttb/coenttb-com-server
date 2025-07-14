//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 25/08/2024.
//

//import Coenttb_Vapor
import Coenttb_Server_Models
//@preconcurrency import Coenttb_Stripe
import Dependencies
import EmailAddress
import Foundation

package struct User: Codable, Hashable, Sendable {
    package typealias ID = UUID
    package var id: ID?
    package var email: EmailAddress?
    package var name: String?
    package var authenticated: Bool
    package var isAdmin: Bool?
    package var dateOfBirth: Date?
    package var newsletterSubscribed: Bool?
    package var stripe: User.Stripe?

    package init(
        id: ID? = nil,
        email: EmailAddress? = nil,
        name: String? = nil,
        authenticated: Bool = false,
        isAdmin: Bool? = nil,
        dateOfBirth: Date? = nil,
        newsletterSubscribed: Bool? = nil,
        stripe: User.Stripe? = nil
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.authenticated = authenticated
        self.isAdmin = isAdmin
        self.dateOfBirth = dateOfBirth
        self.newsletterSubscribed = newsletterSubscribed
        self.stripe = stripe
    }
    
    package enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case authenticated
        case isAdmin = "is_admin"
        case dateOfBirth = "date_of_birth"
        case newsletterSubscribed = "newsletter_consent"
        case stripe = "stripe"
    }

    package struct Stripe: Sendable, Codable, Hashable {
        package var customerId: String

//        package typealias SubscriptionStatus = StripeKit.SubscriptionStatus
        package enum SubscriptionStatus: String, Codable, Hashable, Sendable {
            case trialing
            case pastDue
            case active
            case canceled
            case unpaid
            case incomplete
            case incompleteExpired
            case paused
        }
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
