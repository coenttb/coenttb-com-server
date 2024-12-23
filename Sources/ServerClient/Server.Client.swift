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
    public let stripe: ServerClient.Client.Stripe?
    
    public init(
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
    public static let previewValue: Self = .init(newsletter: .previewValue, account: .previewValue, stripe: .previewValue)
}

public enum DatabaseClientKey {}

extension DatabaseClientKey: TestDependencyKey {
    public static let testValue = ServerClient.Client(
        newsletter: .testValue,
        account: .testValue,
        stripe: .testValue
    )
}

extension DependencyValues {
    public var serverClient: ServerClient.Client {
        get { self[DatabaseClientKey.self] }
        set { self[DatabaseClientKey.self] = newValue }
    }
}

extension ServerClient.Client {
    public func deleteCustomerIdFromUser(stripeCustomerId: String) async throws -> ServerModels.User? {
        return try await self.stripe?.delete(stripeCustomerId: stripeCustomerId)
    }
}
