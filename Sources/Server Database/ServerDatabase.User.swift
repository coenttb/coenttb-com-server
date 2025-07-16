import Dependencies
import Fluent
import Foundation
import IssueReporting
import Server_Models

package final class User: Model, @unchecked Sendable {
    package static let schema = "coenttb_users"

    @ID(key: .id)
    package var id: UUID?

    package var identityId: UUID

    @OptionalField(key: FieldKeys.name)
    package var name: String?

    @OptionalField(key: FieldKeys.dateOfBirth)
    package var dateOfBirth: Date?

    @OptionalField(key: FieldKeys.isAdmin)
    package var isAdmin: Bool?

    @OptionalField(key: FieldKeys.newsletterConsent)
    package var newsletterConsent: Bool?

    @Group(key: FieldKeys.stripe)
    package var stripe: User.Stripe

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    package var createdAt: Date?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    package var updatedAt: Date?

    package init() {
        reportIssue("User.init was called directly, but this generates a random UUID instead of an actual identity's id.")
        self.identityId = .init()
    }

    package init(
        id: UUID? = nil,
        identityID: UUID,
        dateOfBirth: Date? = nil,
        stripe: Stripe = Stripe(),
        newsletterConsent: Bool? = nil
    ) {

        self.identityId = identityID
        self.dateOfBirth = dateOfBirth
        self.newsletterConsent = newsletterConsent
        self.stripe = stripe
        self.id = id
    }

    enum FieldKeys {
        static let identityId: FieldKey = "identity_id"
        static let name: FieldKey = "name"
        static let dateOfBirth: FieldKey = "date_of_birth"
        static let isAdmin: FieldKey = "is_admin"
        static let newsletterConsent: FieldKey = "newsletter_consent"
        static let stripe: FieldKey = "stripe"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
}

extension Server_Database.User {
    struct CreateMigration: AsyncMigration {

        var name: String = "Server_Database.User.CreateMigration"

        func prepare(on database: Fluent.Database) async throws {
            try await database.schema(Server_Database.User.schema)
                .id()
                .field(FieldKeys.identityId, .uuid, .required)
                .field(FieldKeys.name, .string)
                .field(FieldKeys.dateOfBirth, .date)
                .field(FieldKeys.isAdmin, .bool)
                .field(FieldKeys.newsletterConsent, .bool)
                .field([FieldKeys.stripe, Stripe.FieldKeys.customerId], .string)
                .field([FieldKeys.stripe, Stripe.FieldKeys.subscription, Stripe.Subscription.FieldKeys.id], .string)
                .field([FieldKeys.stripe, Stripe.FieldKeys.subscription, Stripe.Subscription.FieldKeys.status], .string)
                .field([FieldKeys.stripe, Stripe.FieldKeys.subscription, Stripe.Subscription.FieldKeys.currentPeriodEnd], .string)
                .field([FieldKeys.stripe, Stripe.FieldKeys.subscription, Stripe.Subscription.FieldKeys.paymentMethodId], .string)
                .field([FieldKeys.stripe, Stripe.FieldKeys.subscription, Stripe.Subscription.FieldKeys.plan], .string)
                .field(FieldKeys.createdAt, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .create()
        }

        func revert(on database: Fluent.Database) async throws {
            try await database.schema(Server_Database.User.schema).delete()
        }
    }
}
