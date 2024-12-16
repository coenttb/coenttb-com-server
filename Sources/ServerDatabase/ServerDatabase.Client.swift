import CoenttbWebAccount
import CoenttbWebDatabase
import CoenttbWebNewsletter
import CoenttbWebStripe
import EmailAddress
import ServerModels

@DependencyClient
public struct Client: Sendable {
    public let newsletter: CoenttbWebNewsletter.Client
    public let account: CoenttbWebAccount.Client<ServerModels.User>
    public let stripe: ServerDatabase.Client.Stripe?
}

public enum DatabaseClientKey {}

extension DatabaseClientKey: TestDependencyKey {
    public static let testValue = ServerDatabase.Client(
        newsletter: .testValue,
        account: .testValue,
        stripe: .testValue
    )
}

extension DependencyValues {
    public var database: ServerDatabase.Client {
        get { self[DatabaseClientKey.self] }
        set { self[DatabaseClientKey.self] = newValue }
    }
}

extension ServerDatabase.Client {
    public func deleteCustomerIdFromUser(stripeCustomerId: String) async throws -> ServerModels.User? {
        return try await self.stripe?.delete(stripeCustomerId: stripeCustomerId)
    }
}
