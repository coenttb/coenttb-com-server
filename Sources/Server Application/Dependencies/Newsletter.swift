//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 12/03/2025.
//

import Coenttb_Server
import Coenttb_Newsletter
import Coenttb_Newsletter_Live
import Server_Client
import Server_Dependencies
import Server_Models
import Mailgun
import Coenttb_Com_Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Newsletter: @retroactive DependencyKey {
    static public var liveValue: Self {
        @Dependency(\.coenttb.website.router) var router

        return .init(
            client: .liveValue,
            configuration: .init(
                saveToLocalstorage: true,
                cookieId: { "String.newsletterSubscribed" },
                subscribeAction: { router.url(for: .api(.newsletter(.subscribe(.request(.init()))))) },
                subscribeCaption: { String.subscribe_to_my_newsletter.capitalizingFirstLetter().description },
                subscribeFormId: { "coenttb-web-newsletter-route-subscribe-view" },
                subscribeOverlayId: { "newsletter-overlay-id"},
                unsubscribeAction: { router.url(for: .api(.newsletter(.unsubscribe(.init())))) },
                unsubscribeFormId: { "coenttb-web-newsletter-route-unsubscribe-view" },
                verificationAction: { verify in router.url(for: .api(.newsletter(.subscribe(.verify(.init(token: verify.token, email: verify.email)))))) },
                verificationRedirectURL: { router.url(for: .home) }
            )
        )
    }
}

extension Newsletter {
    public var isSubscribed: Bool {
        @Dependency(\.currentUser) var currentUser
        @Dependency(\.request) var request
        
        return currentUser?.newsletterSubscribed == true || (currentUser?.newsletterSubscribed == nil && request?.cookies[.newsletterSubscribed]?.string == "true")
    }
}

extension Coenttb_Newsletter.Client: @retroactive DependencyKey {
    public static var liveValue: Self {
        Coenttb_Newsletter.Client.live(
            sendVerificationEmail: { email, token in
                @Dependencies.Dependency(\.mailgunClient?.messages.send) var sendEmail
                @Dependencies.Dependency(\.coenttb.website.router) var router
                @Dependencies.Dependency(\.envVars.companyName!) var businessName
                @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var supportEmail
                @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var fromEmail
                
                guard let sendEmail
                else { throw Mailgun.Client.Error.clientIsNil }
                
                return try await sendEmail(
                    .requestEmailVerification(
                        verificationUrl: router.url(for: .page(.newsletter(.subscribe(.verify(.init(token: token, email: email)))))),
                        businessName: "\(businessName)",
                        supportEmail: supportEmail,
                        from: fromEmail,
                        to: email,
                        primaryColor: .green550.withDarkColor(.green600)
                    )
                )
            },
            onSuccessfullyVerified: { email in
                @Dependency(\.mailgunClient) var mailgunClient
                @Dependency(\.envVars.newsletterAddress) var listAddress
                @Dependency(\.logger) var logger
                @Dependency(\.envVars.appEnv) var appEnv
                @Dependency(\.envVars.mailgun?.domain) var domain
                @Dependency(\.envVars.mailgunCompanyEmail) var mailgunCompanyEmail
                @Dependency(\.envVars.companyName) var companyName
                @Dependency(\.envVars) var envVars
                
                guard let mailgunClient
                else { throw Mailgun.Client.Error.clientIsNil }
                
                guard let listAddress else { return }
                
                do {
                    guard
                        let mailgunCompanyEmail,
                        let companyName
                    else { return }
                    
                    @Dependency(\.envVars.appEnv) var appEnv
                    
                    async let addMemberResponse = mailgunClient.mailingLists.addMember(
                        listAddress: listAddress,
                        request: .init(address: email)
                    )
                    async let notificationResponse = mailgunClient.messages.send(
                        Email.notifyOfNewSubscription(
                            from: mailgunCompanyEmail,
                            to: mailgunCompanyEmail,
                            subscriberEmail: email,
                            companyEmail: mailgunCompanyEmail,
                            companyName: companyName
                        )
                    )
                    let (memberResult, messageResult) = try await (addMemberResponse, notificationResponse)
                    logger.info("Added member: \(memberResult)")
                    logger.info("Sent notification: \(messageResult)")
                    
                } catch {
                    logger.error("Error processing subscription: \(error)")
                }
            },
            onUnsubscribed: { email in
                @Dependency(\.mailgunClient) var mailgunClient
                @Dependency(\.envVars.newsletterAddress) var listAddress
                @Dependency(\.logger) var logger
                
                guard let mailgunClient
                else { throw Mailgun.Client.Error.clientIsNil }
                
                guard let listAddress else { return }
                
                let response = try await mailgunClient.mailingLists.deleteMember(listAddress: listAddress, memberAddress: email)
                
                logger.info("\(response)")
            }
        )
    }
}

