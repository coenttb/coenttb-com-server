import CoenttbIdentity
import CoenttbWebDatabase
import CoenttbNewsletter
import CoenttbStripe
import Dependencies
import DependenciesMacros
import EmailAddress
import ServerModels

@DependencyClient
package struct Client: Sendable {
    package let newsletter: CoenttbNewsletter.Client
    package let account: CoenttbIdentity.Client<ServerModels.User>
    package let stripe: ServerClient.Client.Stripe?
    
    package init(
        newsletter: CoenttbNewsletter.Client,
        account: CoenttbIdentity.Client<ServerModels.User>,
        stripe: ServerClient.Client.Stripe?
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
    package static let testValue = ServerClient.Client(
        newsletter: .testValue,
        account: .testValue,
        stripe: .testValue
    )
}

extension DependencyValues {
    package var serverClient: ServerClient.Client {
        get { self[DatabaseClientKey.self] }
        set { self[DatabaseClientKey.self] = newValue }
    }
}

extension ServerClient.Client {
    package func deleteCustomerIdFromUser(stripeCustomerId: String) async throws -> ServerModels.User? {
        return try await self.stripe?.delete(stripeCustomerId: stripeCustomerId)
    }
}
