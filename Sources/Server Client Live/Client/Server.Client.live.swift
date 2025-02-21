import Coenttb_Vapor
import Coenttb_Fluent
import Coenttb_Newsletter
import Server_EnvVars
import Mailgun
import Messages
import Server_Dependencies
import Server_Database
import Server_Models
import Coenttb_Com_Shared
import Server_Client
import Coenttb_Identity_Consumer

extension Server_Client.Client {
    package static func live(
        database: Fluent.Database
    ) -> Self {
        @Dependencies.Dependency(\.envVars.appEnv) var appEnv
        @Dependencies.Dependency(\.logger) var logger
//        @Dependencies.Dependency(\.stripe?.client) var stripeClient
        
        return .init(
            newsletter: Coenttb_Newsletter.Client.live(
                database: database,
                logger: logger,
                notifyOfNewSubscriptionEmail: {
                    @Dependency(\.envVars.appEnv) var appEnv
                    @Dependency(\.envVars.mailgun?.domain) var domain
                    @Dependency(\.envVars.mailgunCompanyEmail) var mailgunCompanyEmail
                    @Dependency(\.envVars.companyName) var companyName
                    @Dependency(\.envVars) var envVars
                    
                    guard
                        let mailgunCompanyEmail,
                        let companyName
                    else { return .none }
                    
                    return { subscriberEmail in
                        Email.notifyOfNewSubscription(
                            from: mailgunCompanyEmail,
                            to: mailgunCompanyEmail,
                            subscriberEmail: subscriberEmail,
                            companyEmail: mailgunCompanyEmail,
                            companyName: companyName
                        )
                    }
                }(),
                sendEmail: {
                    @Dependency(\.mailgunClient?.messages.send) var sendEmail
                    
                    guard let sendEmail
                    else { return nil }
                    
                    return { email in try await sendEmail(email) }
                }(),
                sendVerificationEmail: Coenttb_Newsletter.Client.sendVerificationEmail,
                onSuccessfullyVerified: { email in
                    @Dependency(\.mailgunClient) var mailgunClient
                    @Dependency(\.envVars.newsletterAddress) var listAddress
                    
                    guard
                        let listAddress,
                        let response = try await mailgunClient?.mailingLists.addMember(
                        listAddress: listAddress,
                        request: .init(
                            address: email
                        )
                    )
                    else {
                        return
                    }
                    
                    logger.info("\(response)")
                },
                onUnsubscribed: { email in
                    @Dependency(\.mailgunClient) var mailgunClient
                    @Dependency(\.envVars.newsletterAddress) var listAddress
                    
                    guard
                        let listAddress,
                        let response = try await mailgunClient?.mailingLists.deleteMember(listAddress: listAddress, memberAddress: email)
                    else {
                        return
                    }
                    
                    logger.info("\(response)")
                }
            ),
            identity: Identity.Consumer.Client.live()
//            stripe: stripeClient.map(Server_Client.Client.Stripe.live(stripeClient:))
        )
    }
}

extension Coenttb_Newsletter.Client {
    package static func sendVerificationEmail(email: EmailAddress, token: String) async throws -> Messages.Send.Response {
        @Dependencies.Dependency(\.mailgunClient!.messages.send) var sendEmail
        @Dependencies.Dependency(\.fireAndForget) var fireAndForget
        @Dependencies.Dependency(\.coenttb.website.router) var router
        @Dependencies.Dependency(\.envVars.companyName!) var businessName
        @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var supportEmail
        @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var fromEmail
        
        fatalError()
//
//        return try await sendEmail(
//            .requestEmailVerification(
//                verificationUrl: router.url(for: .page(.newsletter(.subscribe(.verify(.init(token: token, email: email.rawValue)))))),
//                businessName: "\(businessName)",
//                supportEmail: supportEmail,
//                from: fromEmail,
//                to: (name: nil, email: email),
//                primaryColor: .green550.withDarkColor(.green600)
//            )
//        )
    }
}
