import Server_Application
import Coenttb_Server
import Coenttb_Newsletter
import Coenttb_Syndication_Vapor
import Mailgun
import Server_Models
import Coenttb_Com_Shared
import Server_Client
import Coenttb_Vapor
import Coenttb_Com_Router
import Coenttb_Identity_Consumer

extension Coenttb_Com_Router.Route.API {
    static func response(
        api: Coenttb_Com_Router.Route.API
    ) async throws -> any AsyncResponseEncodable {
        @Dependency(\.logger) var logger

        switch api {
            
            case .newsletter(let newsletter):

                @Dependency(\.serverClient.newsletter) var client

                return try await Coenttb_Newsletter.API.response(newsletter: newsletter)

            case .identity(let identity):
            return try await Coenttb_Identity_Consumer.Identity.Consumer.API.response(api: identity)

                

            case .syndication(_):

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

//extension Server_Models.User {
//    init?(update: Coenttb_Identity.API.Update) {
//        @Dependency(\.currentUser) var currentUser
//
//        guard var user = currentUser else {
//            return nil
//        }
//
//        if let newName = update.name {
//            user.name = newName.isEmpty ? nil : newName
//        }
//
//        self = user
//    }
//}



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
