import Coenttb
import Coenttb_Server
import Coenttb_Identity
import Coenttb_Identity_Live
import Coenttb_Identity_Fluent
import Coenttb_Newsletter
import Coenttb_Syndication_Vapor
import Mailgun
import Server_Models
import Server_Router
import Server_Client
import Coenttb_Vapor
//import Coenttb_Stripe
//import Coenttb_Stripe_Live

extension Server_RouterAPI {
    static func response(
        api: Server_RouterAPI
    ) async throws -> any AsyncResponseEncodable {
        @Dependency(\.logger) var logger

        switch api {
        case let .v1(v1):
            switch v1 {
            case .newsletter(let newsletter):

                @Dependency(\.serverClient.newsletter) var client

                return try await Coenttb_Newsletter.API.response(
                    client: client,
                    logger: logger,
                    cookieId: String.newsletterSubscribed,
                    newsletter: newsletter
                )

            case .account(let account):

                @Dependency(\.serverClient.account) var database

                return try await Coenttb_Identity.API.response(
                    api: account,
                    client: database,
                    userInit: Server_Models.User.init(update:),
                    reauthenticateForEmailChange: { password in
                        @Dependency(\.currentUser) var currentUser
                        @Dependency(\.serverClient.account) var database
                        @Dependency(\.request?.db) var db

                        guard
                            let email = currentUser?.email,
                            let id = currentUser?.id,
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
                        @Dependency(\.serverClient.account) var database
                        @Dependency(\.request?.db) var db

                        guard
                            let email = currentUser?.email,
                            let id = currentUser?.id,
                            let db
                        else { throw Abort(.internalServerError) }

                        try await database.login(email: email, password: password)

                        guard let identity = try await Identity.find(id, on: db)
                        else { throw Abort(.internalServerError, reason: "Couldn't find identity") }

                        let token = try Identity.Token(identity: identity, type: .reauthenticationToken)
                        try await token.save(on: db)
                    },
                    logoutRedirectURL: { try await WebsitePage.response(page: .home) }
                )
                
                
                

//            case .stripe(let stripe):
//                @Dependency(\.envVars.stripe.publishableKey) var publishableKey
//
//                return try await Coenttb_Stripe.API.response(
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
//                        @Dependency(\.serverClient.account) var database
//                        var updatedUser = currentUser
//                        updatedUser?.stripe?.customerId = newStripeCustomerId
//                        _ = try await database.update(updatedUser)
//                    },
//                    checkIfStripeCustomerIdAlreadyExists: {
//                        @Dependency(\.currentUser) var currentUser
//                        return currentUser?.stripe?.customerId
//                    }
//                )

            case .rss(_):

//                let width = 400
//                let height = 500
//
//                let image = Image(width: width, height: height)
//                image?.colorize(using: .red)
//
//                guard let pngData = try image?.export(as: .png)
//                else {
//                    throw Abort(.internalServerError, reason: "Failed to generate PNG")
//                }
//
//                // Return the image with correct headers
//                var headers = HTTPHeaders()
//                headers.add(name: .contentType, value: "image/png")
//
//                return Response(status: .ok, headers: headers, body: .init(data: pngData))
                
                return Response.ok
            }
        }
    }
}

extension Server_Models.User {
    init?(update: Coenttb_Identity.API.Update) {
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
