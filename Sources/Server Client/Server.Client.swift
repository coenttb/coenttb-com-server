import Coenttb_Database
import Coenttb_Newsletter
//import Coenttb_Stripe
import Dependencies
import DependenciesMacros
import EmailAddress
import Server_Models
import Coenttb_Identity_Consumer

@DependencyClient
package struct Client: Sendable {
    package let newsletter: Coenttb_Newsletter.Client
    package let identity: Identity.Consumer.Client
//    package let stripe: Server_Client.Client.Stripe?
    
    package init(
        newsletter: Coenttb_Newsletter.Client,
        identity: Identity.Consumer.Client
//        stripe: Server_Client.Client.Stripe?
    ) {
        self.newsletter = newsletter
        self.identity = identity
//        self.stripe = stripe
    }
}

extension Client {
    package static let previewValue: Self = .init(
        newsletter: .previewValue,
        identity: .previewValue
//        stripe: .previewValue
    )
}

package enum DatabaseClientKey {}

extension DatabaseClientKey: TestDependencyKey {
    package static let testValue = Server_Client.Client(
        newsletter: .testValue,
        identity: .testValue
//        stripe: .testValue
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
        fatalError()
//        return try await self.stripe?
//            .delete(stripeCustomerId: stripeCustomerId)
    }
}
