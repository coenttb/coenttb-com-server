//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 04/10/2024.
//

import Coenttb_Identity
import Coenttb_Identity_Fluent
import Coenttb_Server_Models
import Foundation
import Server_Models
import Server_Client
import Server_Database

extension Server_Models.User {
    init(
        _ identity: Coenttb_Identity_Fluent.Identity,
        user: Server_Database.User
    ) throws {
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
