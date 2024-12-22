import CoenttbIdentity
import CoenttbWebDatabase
import CoenttbNewsletter
import CoenttbStripe
import Dependencies
import DependenciesMacros
import EmailAddress
import ServerModels

@DependencyClient
public struct Client: Sendable {
    public let newsletter: CoenttbNewsletter.Client
    public let account: CoenttbIdentity.Client<ServerModels.User>
    public let stripe: ServerDatabase.Client.Stripe?
}

extension Client {
    public static let noop: Self = .init(newsletter: .previewValue, account: .previewValue, stripe: .previewValue)
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
