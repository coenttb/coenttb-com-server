import CoenttbWeb
import CoenttbIdentity
import CoenttbIdentityLive
import CoenttbIdentityFluent
import CoenttbNewsletter
import ServerEnvVars
import Mailgun
import ServerDependencies
import ServerDatabase
import ServerModels
import ServerRouter
import ServerClient

extension ServerClient.Client {
    package static func live(
        database: Fluent.Database
    ) -> Self {
        @Dependencies.Dependency(\.envVars.appEnv) var appEnv
        @Dependencies.Dependency(\.logger) var logger
        @Dependencies.Dependency(\.stripe?.client) var stripeClient
        
        return .init(
            newsletter: CoenttbNewsletter.Client.live(
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
                sendVerificationEmail: CoenttbNewsletter.Client.sendVerificationEmail
            ),
            account: CoenttbIdentity.Client.live(
                database: database,
                logger: logger,
                getDatabaseUser: (
                    byUserId: { userId in
                        try await ServerDatabase.User.query(on: database)
                            .filter(\.$id == userId)
                            .first()
                    },
                    byIdentityId: { identityId in
                        try await ServerDatabase.User.query(on: database)
                            .filter(\.$identity.$id == identityId)
                            .first()
                    }
                ),
                userInit: { identity, user in
                    try! ServerModels.User.init(identity, user: user)
                },
                userUpdate: { update, identity, user in
                    func updateIfPresent<T>(_ value: T?, on property: inout T) {
                        if let newValue = value {
                            property = newValue
                        }
                    }
                    
                    updateIfPresent(update.name, on: &identity.name)
                    updateIfPresent(update.stripe?.customerId, on: &user.stripe.customerId)
                    
                    if let stripeCustomerId = update.stripe?.customerId {
                        user.stripe.customerId = stripeCustomerId
                    }
                    
                    if let stripe = update.stripe {
                        user.stripe.customerId = stripe.customerId
                        user.stripe.subscription.status = stripe.subscriptionStatus
                    }
                },
                createDatabaseUser: { identityId in
                    return ServerDatabase.User(id: nil, identityID: identityId, dateOfBirth: nil, newsletterConsent: true)
                },
                currentUserId: {
                    @Dependencies.Dependency(\.currentUser?.id?.rawValue) var currentUserId
                    return currentUserId
                },
                currentUserEmail: {
                    @Dependencies.Dependency(\.currentUser?.email) var currentUserEmail
                    return currentUserEmail
                },
                request: {
                    @Dependencies.Dependency(\.request) var request
                    return request
                },
                sendVerificationEmail: { email, token in
                    @Dependencies.Dependency(\.mailgunClient?.messages.send) var sendEmail
                    @Dependencies.Dependency(\.fireAndForget) var fireAndForget
                    @Dependencies.Dependency(\.serverRouter) var serverRouter
                    @Dependencies.Dependency(\.envVars.companyName!) var businessName
                    @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var supportEmail
                    @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var fromEmail
                    
                    await fireAndForget {
                        _ = try await sendEmail?(
                            .requestEmailVerification(
                                verificationUrl: serverRouter.url(for: .account(.create(.verify(.init(token: token, email: email.rawValue))))),
                                businessName: "\(businessName)",
                                supportEmail: supportEmail,
                                from: fromEmail,
                                to: (name: nil, email: email),
                                primaryColor: .green550.withDarkColor(.green600)
                            )
                        )
                    }
                },
                authenticate: { (authenticatable: any SessionAuthenticatable) in
                    @Dependencies.Dependency(\.request) var request
                    guard let request else { throw Abort.requestUnavailable }
                    request.auth.login(authenticatable)
                    request.session.authenticate(authenticatable)
                },
                isAuthenticated: {
                    @Dependencies.Dependency(\.request) var request
                    guard let request else { throw Abort.requestUnavailable }
                    let identity = request.auth.get(Identity.self)
                    return identity != nil
                },
                logout: {
                    @Dependencies.Dependency(\.request) var request
                    guard let request else { throw Abort.requestUnavailable }
                    request.auth.logout(Identity.self)
                },
                isValidEmail: /*appEnv == .development ? { _ in true } : */{ _ in true },
                isValidPassword: appEnv == .development ? { _ in true } : Bool.isValidPassword,
                sendPasswordResetEmail: {
                    email,
                    token in
                    @Dependencies.Dependency(\.mailgunClient?.messages.send) var sendEmail
                    @Dependencies.Dependency(\.fireAndForget) var fireAndForget
                    @Dependencies.Dependency(\.currentUser?.name) var currentUserName
                    @Dependencies.Dependency(\.serverRouter) var serverRouter
                    
                    await fireAndForget {
                        _ = try await sendEmail?(
                            Email(
                                business: .fromEnvVars,
                                passwordEmail: .reset(
                                    .request(
                                        .init(
                                            resetUrl: serverRouter.url(for: .account(.password(.reset(.confirm(.init(token: token, newPassword: "")))))),
                                            userName: currentUserName,
                                            userEmail: email
                                        )
                                    )
                                )
                            )
                        )
                    }
                },
                sendPasswordChangeNotification: { email in
                    @Dependencies.Dependency(\.mailgunClient?.messages.send) var sendEmail
                    @Dependencies.Dependency(\.fireAndForget) var fireAndForget
                    @Dependencies.Dependency(\.currentUser?.name) var currentUserName
                    @Dependencies.Dependency(\.serverRouter) var serverRouter
                    
                    await fireAndForget {
                        _ = try await sendEmail?(
                            Email(
                                business: .fromEnvVars,
                                passwordEmail: .change(.notification(.init(userName: currentUserName, userEmail: email)))
                            )
                        )
                    }
                },
                sendEmailChangeConfirmation: { currentEmail, newEmail, token in
                    @Dependencies.Dependency(\.mailgunClient?.messages.send) var sendEmail
                    @Dependencies.Dependency(\.fireAndForget) var fireAndForget
                    @Dependencies.Dependency(\.currentUser?.name) var currentUserName
                    @Dependencies.Dependency(\.serverRouter) var serverRouter
                    
                    await fireAndForget {
                        _ = try await sendEmail?(
                            Email(
                                business: .fromEnvVars,
                                emailChange: .confirmation(
                                    .request(
                                        .init(
                                            verificationURL: serverRouter.url(for: .account(.emailChange(.confirm(.init(token: token))))),
                                            currentEmail: currentEmail,
                                            newEmail: newEmail,
                                            userName: currentUserName
                                        )
                                    )
                                )
                            )
                        )
                    }
                },
                sendEmailChangeRequestNotification: { currentEmail, newEmail in
                    @Dependencies.Dependency(\.mailgunClient?.messages.send) var sendEmail
                    @Dependencies.Dependency(\.fireAndForget) var fireAndForget
                    @Dependencies.Dependency(\.currentUser?.name) var currentUserName
                    @Dependencies.Dependency(\.serverRouter) var serverRouter
                    
                    await fireAndForget {
                        _ = try await sendEmail?(
                            Email(
                                business: .fromEnvVars,
                                emailChange: .request(
                                    .notification(
                                        .init(
                                            currentEmail: currentEmail,
                                            newEmail: newEmail,
                                            userName: currentUserName
                                        )
                                    )
                                )
                            )
                        )
                    }
                },
                onEmailChangeSuccess: { currentEmail, newEmail in
                    @Dependencies.Dependency(\.mailgunClient?.messages.send) var sendEmail
                    @Dependencies.Dependency(\.fireAndForget) var fireAndForget
                    @Dependencies.Dependency(\.currentUser?.name) var currentUserName
                    @Dependencies.Dependency(\.currentUser?.stripe?.customerId) var stripeCustomerId
                    @Dependencies.Dependency(\.serverRouter) var serverRouter
                    @Dependencies.Dependency(\.stripe) var stripe
                    @Dependencies.Dependency(\.logger) var logger
                    
                    try await database.transaction { database in
                        do {
                            guard let identity = try await Identity.query(on: database)
                                .filter(\.$email == newEmail.rawValue)
                                .first()
                            else {
                                logger.error("Could not find user with email \(currentEmail) when updating Stripe")
                                return
                            }
                            
                            let user = try await ServerDatabase.User.query(on: database)
                                .filter(\.$identity.$id == identity.id!)
                                .first()
                            
                            guard let user = user
                            else { return }
                            
                            guard let customerId = user.stripe.customerId
                            else {
                                logger.info("Couldn't find stripeCustomerId")
                                return
                            }
                            
                            _ = try await stripe?.customers.update(
                                customer: customerId,
                                email: newEmail.rawValue
                            )
                            logger.info("Successfully updated Stripe customer \(customerId) email to \(newEmail)")
                        } catch {
                            logger.error("Failed to update Stripe customer email: \(error.localizedDescription)")
                        }
                    }
                    
                    await fireAndForget {
                        try await withThrowingTaskGroup(of: Void.self) { [sendEmail, currentEmail, newEmail, currentUserName] group in
                            group.addTask {
                                _ = try await sendEmail?(
                                    Email(
                                        business: .fromEnvVars,
                                        emailChange: .confirmation(
                                            .notification(
                                                .currentEmail(
                                                    .init(
                                                        currentEmail: currentEmail,
                                                        newEmail: newEmail,
                                                        userName: currentUserName
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )
                            }
                            group.addTask {
                                _ = try await sendEmail?(
                                    Email(
                                        business: .fromEnvVars,
                                        emailChange: .confirmation(
                                            .notification(
                                                .newEmail(
                                                    .init(
                                                        currentEmail: currentEmail,
                                                        newEmail: newEmail,
                                                        userName: currentUserName
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )
                            }
                            
                            try await group.waitForAll()
                        }
                    }
                }
            ),
            stripe: stripeClient.map(ServerClient.Client.Stripe.live(stripeClient:))
        )
    }
}

extension BusinessDetails {
    package static let fromEnvVars: BusinessDetails = {
        @Dependency(\.envVars.mailgun?.domain) var domain
        
        @Dependencies.Dependency(\.envVars.companyName!) var businessName
        @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var supportEmail
        @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var fromEmail
        
        return BusinessDetails(
            name: businessName,
            supportEmail: supportEmail,
            fromEmail: fromEmail,
            primaryColor: .green550.withDarkColor(.green600)
        )
    }()
}

extension CoenttbNewsletter.Client {
    package static func sendVerificationEmail(email: EmailAddress, token: String) async throws -> Mailgun.Messages.Send.Response {
        @Dependencies.Dependency(\.mailgunClient!.messages.send) var sendEmail
        @Dependencies.Dependency(\.fireAndForget) var fireAndForget
        @Dependencies.Dependency(\.serverRouter) var serverRouter
        @Dependencies.Dependency(\.envVars.companyName!) var businessName
        @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var supportEmail
        @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var fromEmail
        
        return try await sendEmail(
            .requestEmailVerification(
                verificationUrl: serverRouter.url(for: .newsletter(.subscribe(.verify(.init(token: token, email: email.rawValue))))),
                businessName: "\(businessName)",
                supportEmail: supportEmail,
                from: fromEmail,
                to: (name: nil, email: email),
                primaryColor: .green550.withDarkColor(.green600)
            )
        )
    }
}
