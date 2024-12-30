//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/10/2024.
//

import Coenttb_Identity
import Coenttb_Database
import Coenttb_Newsletter
import Coenttb_Stripe
import Dependencies
import DependenciesMacros
import EmailAddress
import Server_Models
import StripeKit

extension Server_Client.Client {
    @DependencyClient
    package struct Stripe: @unchecked Sendable {
        @DependencyEndpoint
        package var readSubscriptionStatus: (_ stripeCustomerId: String) async throws -> SubscriptionStatus?

        @DependencyEndpoint
        package var delete: (_ stripeCustomerId: String) async throws -> Server_Models.User?
    }
}

extension Server_Client.Client.Stripe: TestDependencyKey {
    package static var testValue: Self { .init() }
}
