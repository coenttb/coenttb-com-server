import CoenttbWebAccount
import CoenttbWebDatabase
import EmailAddress
import Foundation
import MemberwiseInit
import Queues
import ServerModels
import Tagged

final class User: Model, @unchecked Sendable {
    static let schema = "coenttb_users"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: FieldKeys.identityId)
    var identity: CoenttbWebAccount.Identity

    @OptionalField(key: FieldKeys.dateOfBirth)
    var dateOfBirth: Date?

    @OptionalField(key: FieldKeys.newsletterConsent)
    var newsletterConsent: Bool?

    @Group(key: FieldKeys.stripe)
    var stripe: Stripe

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?

    @OptionalField(key: FieldKeys.deletionState)
    var deletionState: DeletionState?

    // The time when the deletion was requested, relevant if the deletionState is pending
    @OptionalField(key: FieldKeys.deletionRequestedAt)
    var deletionRequestedAt: Date?

    init() {}

    init(
        id: UUID? = nil,
        identityID: CoenttbWebAccount.Identity.IDValue,
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

    enum DeletionState: String, Codable {
        case pending
        case deleted
    }
}

extension ServerDatabase.User {
    struct CreateMigration: AsyncMigration {
        func prepare(on database: Fluent.Database) async throws {
            try await database.schema(ServerDatabase.User.schema)
                .id()
                .field(FieldKeys.identityId, .uuid, .required, .references(CoenttbWebAccount.Identity.schema, .id))
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

public struct ConfirmDeleteUserJob: AsyncScheduledJob {

    @Dependency(\.logger) var logger

    public init() {}

    // The payload here is the user's email (optional since this is a scheduled job)
    typealias Payload = String

    // Scheduled job execution
    public func run(context: QueueContext) async throws {
        let db = context.application.db
        let currentTime = Date.now
        let gracePeriodDuration: TimeInterval = 7 * 24 * 60 * 60 // 7 days

        let usersPendingDeletion = try await ServerDatabase.User.query(on: db)
            .filter(\.$deletionState == .pending)
            .all()

        for user in usersPendingDeletion {
            if let requestedAt = user.deletionRequestedAt {
                let elapsedTime = currentTime.timeIntervalSince(requestedAt)

                // If the grace period has passed, delete the user
                if elapsedTime >= gracePeriodDuration {
                    user.deletionState = .deleted
                    user.deletionRequestedAt = nil // No longer needed after deletion
                    try await user.save(on: db)

                    // Log the deletion
                    logger.info("ServerDatabase.User \(user.id?.uuidString ?? "unknown") has been permanently deleted.")
                } else {
                    // Log that the user is still within the grace period
                    logger.info("ServerDatabase.User \(user.id?.uuidString ?? "unknown") is still within the grace period.")
                }
            }
        }
    }
}
