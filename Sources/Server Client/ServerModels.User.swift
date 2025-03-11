//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 04/10/2024.
//

import Coenttb_Server_Models
import Foundation
import Server_Database
import Coenttb_Identity_Consumer
import SwiftWeb
import Server_Models

extension Server_Models.User {
    init(
        accessToken: JWT.Token.Access,
        user: Server_Database.User
    ) throws {
        self = .init(
            id: accessToken.identityId,
            email: accessToken.emailAddress,
            name: user.name,
            authenticated: true,
            isAdmin: user.isAdmin,
            dateOfBirth: user.dateOfBirth,
            newsletterSubscribed: user.newsletterConsent
//            stripe: user.stripe.customerId.map { customerId in
//                user.stripe.subscription.status.map { subscriptionStatus in
//                        .init(customerId: customerId, subscriptionStatus: subscriptionStatus)
//                } ?? .init(customerId: customerId, subscriptionStatus: .none)
//            }
        )
    }
}
