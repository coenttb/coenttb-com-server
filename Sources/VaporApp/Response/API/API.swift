import Coenttb
import CoenttbWebAccount
import CoenttbWebAccountLive
import CoenttbWebHTML
import CoenttbWebNewsletter
import CoenttbWebStripe
import CoenttbWebStripeLive
import Dependencies
import Fluent
import Foundation
import Languages
import Mailgun
import ServerModels
import ServerRouter
import Vapor

extension ServerRouterAPI {
    static func response(
        api: ServerRouterAPI
    ) async throws -> any AsyncResponseEncodable {
        @Dependency(\.logger) var logger

        switch api {
        case let .v1(v1):
            switch v1 {
            case .newsletter(let newsletter):

                @Dependency(\.database.newsletter) var client

                return try await CoenttbWebNewsletter.API.response(
                    client: client,
                    logger: logger,
                    cookieId: String.newsletterSubscribed,
                    newsletter: newsletter
                )

            case .account(let account):

                @Dependency(\.database.account) var database

                return try await CoenttbWebAccount.API.response(
                    logoutRedirectURL: { try await WebsitePage.response(page: .home) },
                    account: account,
                    database: database,
                    userInit: ServerModels.User.init(update:),
                    reauthenticateForEmailChange: { password in
                        @Dependency(\.currentUser) var currentUser
                        @Dependency(\.database.account) var database
                        @Dependency(\.request?.db) var db

                        guard
                            let email = currentUser?.email?.rawValue,
                            let id = currentUser?.id?.rawValue,
                            let db
                        else { throw Abort(.internalServerError) }

                        try await database.login(email: email, password: password)

                        guard let identity = try await Identity.find(id, on: db)
                        else { throw Abort(.internalServerError, reason: "Couldn't find identity") }

                        let token = try Identity.Token(identity: identity, type: .reauthenticationToken)
                        try await token.save(on: db)
                    },
                    reauthenticateForPasswordChange: { password in
                        @Dependency(\.currentUser) var currentUser
                        @Dependency(\.database.account) var database
                        @Dependency(\.request?.db) var db

                        guard
                            let email = currentUser?.email?.rawValue,
                            let id = currentUser?.id?.rawValue,
                            let db
                        else { throw Abort(.internalServerError) }

                        try await database.login(email: email, password: password)

                        guard let identity = try await Identity.find(id, on: db)
                        else { throw Abort(.internalServerError, reason: "Couldn't find identity") }

                        let token = try Identity.Token(identity: identity, type: .reauthenticationToken)
                        try await token.save(on: db)
                    }
                )

//            case .stripe(let stripe):
//                @Dependency(\.envVars.stripe.publishableKey) var publishableKey
//
//                return try await CoenttbWebStripe.API.response(
//                    stripe: stripe,
//                    publishableKey: publishableKey,
//                    productLookupKeys: Coenttb.Stripe.monthlyBlogSubscriptionPriceLookupKey,
//                    currentUserStripeCustomerId: {
//                        @Dependency(\.currentUser?.stripe?.customerId) var currentUserStripeCustomerId
//                        return currentUserStripeCustomerId
//                    },
//                    subscriber_email: {
//                        @Dependency(\.currentUser?.email) var subscriber_email
//                        return subscriber_email?.rawValue
//                    },
//                    subscriber_name: {
//                        @Dependency(\.currentUser?.name) var subscriber_name
//                        return subscriber_name
//                    },
//                    updateUser: { newStripeCustomerId in
//                        @Dependency(\.currentUser) var currentUser
//                        @Dependency(\.database.account) var database
//                        var updatedUser = currentUser
//                        updatedUser?.stripe?.customerId = newStripeCustomerId
//                        _ = try await database.update(updatedUser)
//                    },
//                    checkIfStripeCustomerIdAlreadyExists: {
//                        @Dependency(\.currentUser) var currentUser
//                        return currentUser?.stripe?.customerId
//                    }
//                )

            }
        }
    }
}

extension ServerModels.User {
    init?(update: CoenttbWebAccount.API.Update) {
        @Dependency(\.currentUser) var currentUser

        guard var user = currentUser else {
            return nil
        }

        if let newName = update.name {
            user.name = newName.isEmpty ? nil : newName
        }

        self = user
    }
}
