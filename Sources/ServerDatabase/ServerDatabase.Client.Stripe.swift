//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/10/2024.
//

import CoenttbWebAccount
import CoenttbWebDatabase
import CoenttbWebNewsletter
import CoenttbWebStripe
import EmailAddress
import ServerModels
import StripeKit

extension ServerDatabase.Client {
    @DependencyClient
    public struct Stripe: @unchecked Sendable {
        @DependencyEndpoint
        public var readSubscriptionStatus: (_ stripeCustomerId: String) async throws -> SubscriptionStatus?

        @DependencyEndpoint
        public var delete: (_ stripeCustomerId: String) async throws -> ServerModels.User?
    }
}

extension ServerDatabase.Client.Stripe: TestDependencyKey {
    public static var testValue: Self { .init() }
}
