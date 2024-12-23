import CoenttbIdentity
import CoenttbWebDatabase
import CoenttbNewsletter
import CoenttbStripe
import Dependencies
import DependenciesMacros
import EmailAddress
import Server_Models

@DependencyClient
package struct Client: Sendable {
    package let newsletter: CoenttbNewsletter.Client
    package let account: CoenttbIdentity.Client<Server_Models.User>
    package let stripe: Server_Client.Client.Stripe?
    
    package init(
        newsletter: CoenttbNewsletter.Client,
        account: CoenttbIdentity.Client<Server_Models.User>,
        stripe: Server_Client.Client.Stripe?
    ) {
        self.newsletter = newsletter
        self.account = account
        self.stripe = stripe
    }
}

extension Client {
    package static let previewValue: Self = .init(newsletter: .previewValue, account: .previewValue, stripe: .previewValue)
}

package enum DatabaseClientKey {}

extension DatabaseClientKey: TestDependencyKey {
    package static let testValue = Server_Client.Client(
        newsletter: .testValue,
        account: .testValue,
        stripe: .testValue
    )
}

extension DependencyValues {
    package var serverClient: Server_Client.Client {
        get { self[DatabaseClientKey.self] }
        set { self[DatabaseClientKey.self] = newValue }
    }
}

extension Server_Client.Client {
    package func deleteCustomerIdFromUser(stripeCustomerId: String) async throws -> Server_Models.User? {
        return try await self.stripe?.delete(stripeCustomerId: stripeCustomerId)
    }
}
