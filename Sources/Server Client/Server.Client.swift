import Coenttb_Database
import Coenttb_Newsletter
import Dependencies
import DependenciesMacros
import EmailAddress
import Server_Models

@DependencyClient
package struct Client: Sendable {
    package let newsletter: Newsletter.Client
    package let user: Client.User
//    package let stripe: Server_Client.Client.Stripe?

    package init(
        newsletter: Newsletter.Client,
        user: Client.User
//        stripe: Server_Client.Client.Stripe?
    ) {
        self.newsletter = newsletter
        self.user = user
//        self.stripe = stripe
    }
}

extension Client {
    package static let previewValue: Self = .init(
        newsletter: .previewValue,
        user: .previewValue
//        stripe: .previewValue
    )
}

extension Server_Client.Client: TestDependencyKey {
    package static let testValue: Self = .init(
        newsletter: .testValue,
        user: .testValue
//        stripe: .testValue
    )
}

extension DependencyValues {
    package var serverClient: Server_Client.Client {
        get { self[Server_Client.Client.self] }
        set { self[Server_Client.Client.self] = newValue }
    }
}

extension Server_Client.Client {
    package func deleteCustomerIdFromUser(stripeCustomerId: String) async throws -> Server_Models.User? {
        fatalError()
//        return try await self.stripe?
//            .delete(stripeCustomerId: stripeCustomerId)
    }
}
