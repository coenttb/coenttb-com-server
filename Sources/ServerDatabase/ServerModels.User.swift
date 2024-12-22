//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 04/10/2024.
//

import CoenttbIdentity
import CoenttbIdentityFluent
import CoenttbWebModels
import Foundation
import ServerModels

extension ServerModels.User {
    init(_ identity: Identity, user: ServerDatabase.User) throws {
        self = .init(
            id: .init(identity.id!),
            email: try .init(identity.email),
            name: identity.name,
            authenticated: true,
            isAdmin: identity.isAdmin,
            isEmailVerified: identity.emailVerificationStatus == .verified,
            dateOfBirth: user.dateOfBirth,
            newsletterSubscribed: user.newsletterConsent,
            stripe: user.stripe.customerId.map { customerId in
                user.stripe.subscription.status.map { subscriptionStatus in
                        .init(customerId: customerId, subscriptionStatus: subscriptionStatus)
                } ?? .init(customerId: customerId, subscriptionStatus: .none)
            }
        )
    }
}
