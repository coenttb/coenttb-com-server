import Foundation
import Dependencies
import Fluent
import ServerModels
import CoenttbIdentity
import CoenttbIdentityFluent
@preconcurrency import CoenttbStripe


public final class User: Model, @unchecked Sendable {
    public static let schema = "coenttb_users"

    @ID(key: .id)
    public var id: UUID?

    @Parent(key: FieldKeys.identityId)
    public var identity: CoenttbIdentityFluent.Identity

    @OptionalField(key: FieldKeys.dateOfBirth)
    public var dateOfBirth: Date?

    @OptionalField(key: FieldKeys.newsletterConsent)
    public var newsletterConsent: Bool?

    @Group(key: FieldKeys.stripe)
    public var stripe: User.Stripe

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    public var createdAt: Date?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    public var updatedAt: Date?

    @OptionalField(key: FieldKeys.deletionState)
    public var deletionState: DeletionState?

    @OptionalField(key: FieldKeys.deletionRequestedAt)
    public var deletionRequestedAt: Date?

    public init() {}

    public init(
        id: UUID? = nil,
        identityID: CoenttbIdentityFluent.Identity.IDValue,
        dateOfBirth: Date? = nil,
        stripe: Stripe = Stripe(),
        newsletterConsent: Bool? = nil
    ) {
        self.id = id
        self.$identity.id = identityID
        self.dateOfBirth = dateOfBirth
        self.newsletterConsent = newsletterConsent
        self.stripe = stripe
    }

    enum FieldKeys {
        static let identityId: FieldKey = "identity_id"
        static let dateOfBirth: FieldKey = "date_of_birth"
        static let newsletterConsent: FieldKey = "newsletter_consent"
        static let stripe: FieldKey = "stripe"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
        static let deletionState: FieldKey = "deletion_state"
        static let deletionRequestedAt: FieldKey = "deletion_requested_at"
    }

    public enum DeletionState: String, Codable, Sendable {
        case pending
        case deleted
    }
}

extension ServerDatabase.User {
    struct CreateMigration: AsyncMigration {
        
        var name: String = "ServerDatabase.User.CreateMigration"
        
        func prepare(on database: Fluent.Database) async throws {
            try await database.schema(ServerDatabase.User.schema)
                .id()
                .field(FieldKeys.identityId, .uuid, .required, .references(CoenttbIdentityFluent.Identity.schema, .id))
                .field(FieldKeys.dateOfBirth, .date)
                .field(FieldKeys.newsletterConsent, .bool)
                .field([FieldKeys.stripe, Stripe.FieldKeys.customerId], .string)
                .field([FieldKeys.stripe, Stripe.FieldKeys.subscription, Stripe.Subscription.FieldKeys.id], .string)
                .field([FieldKeys.stripe, Stripe.FieldKeys.subscription, Stripe.Subscription.FieldKeys.status], .string)
                .field([FieldKeys.stripe, Stripe.FieldKeys.subscription, Stripe.Subscription.FieldKeys.currentPeriodEnd], .string)
                .field([FieldKeys.stripe, Stripe.FieldKeys.subscription, Stripe.Subscription.FieldKeys.paymentMethodId], .string)
                .field([FieldKeys.stripe, Stripe.FieldKeys.subscription, Stripe.Subscription.FieldKeys.plan], .string)
                .field(FieldKeys.createdAt, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .field(FieldKeys.deletionState, .string)
                .field(FieldKeys.deletionRequestedAt, .datetime)
                .create()
        }

        func revert(on database: Fluent.Database) async throws {
            try await database.schema(ServerDatabase.User.schema).delete()
        }
    }
}

