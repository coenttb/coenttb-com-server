import CoenttbWebAccount
import CoenttbWebDatabase
import CoenttbWebHTML
import CoenttbWebNewsletter
import CoenttbWebUtils
import EmailAddress
import EnvVars
import Mailgun
import PostgresKit
import ServerDependencies
import ServerModels
import ServerRouter

extension ServerDatabase.Client {
    public static func live(
        database: Fluent.Database
    ) -> Self {

        @Dependencies.Dependency(\.envVars.appEnv) var appEnv
        @Dependencies.Dependency(\.logger) var logger
        @Dependencies.Dependency(\.stripe?.client) var stripeClient

        return .init(
            newsletter: .live(
                database: database,
                logger: logger,
                notifyOfNewSubscriptionEmail: {
                    @Dependency(\.envVars.appEnv) var appEnv
                    @Dependency(\.envVars.mailgun?.domain) var domain
                    @Dependency(\.envVars.mailgunCompanyEmail) var mailgunCompanyEmail
                    @Dependency(\.envVars) var envVars

                    guard
                        let domain,
                        let mailgunCompanyEmail,
                        let companyName = envVars.companyName
                    else { return nil }
                    
                    let companyEmail: EmailAddress = switch appEnv {
                    case .production: .init(mailgunCompanyEmail)
                    default: .init("\(companyName) <postmaster@\(domain.rawValue)>")
                    }
                    return { subscriberEmail in
                        Email.notifyOfNewSubscription(
                            companyName: companyName,
                            to: .init(mailgunCompanyEmail),
                            companyEmail: companyEmail,
                            subscriberEmail: .init(subscriberEmail),
                            domain: domain.rawValue
                        )
                    }
                }(),
                sendEmail: {
                    @Dependency(\.mailgun?.sendEmail) var sendEmail

                    guard let sendEmail
                    else { return nil }

                    return { email in try await sendEmail(email) }
                }()
            ),
            account: .live(
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
                    ServerModels.User.init(identity, user: user)
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
                    @Dependencies.Dependency(\.currentUser?.email?.rawValue) var currentUserEmail
                    return currentUserEmail
                },
                request: {
                    @Dependencies.Dependency(\.request) var request
                    return request
                },
                sendVerificationEmail: { email, token in
                    @Dependencies.Dependency(\.mailgun?.sendEmail) var sendEmail
                    @Dependencies.Dependency(\.fireAndForget) var fireAndForget
                    @Dependencies.Dependency(\.serverRouter) var serverRouter
                    @Dependencies.Dependency(\.envVars.companyName!) var businessName
                    @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var supportEmail
                    @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var fromEmail

                    await fireAndForget {
                        _ = try await sendEmail?(
                            .requestEmailVerification(
                                verificationUrl: serverRouter.url(for: .account(.create(.verify(.init(token: token, email: email))))),
                                businessName: "\(businessName)",
                                supportEmail: supportEmail,
                                from: "\(businessName) <\(fromEmail)>",
                                to: (name: nil, email: .init(email)),
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
                isValidEmail: /*appEnv == .development ? { _ in true } : */Bool.isValidEmail,
                isValidPassword: appEnv == .development ? { _ in true } : Bool.isValidPassword,
                sendPasswordResetEmail: {
                    email,
                    token in
                    @Dependencies.Dependency(\.mailgun?.sendEmail) var sendEmail
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
                                            userEmail: .init(email)
                                        )
                                    )
                                )
                            )
                        )
                    }
                },
                sendPasswordChangeNotification: { email in
                    @Dependencies.Dependency(\.mailgun?.sendEmail) var sendEmail
                    @Dependencies.Dependency(\.fireAndForget) var fireAndForget
                    @Dependencies.Dependency(\.currentUser?.name) var currentUserName
                    @Dependencies.Dependency(\.serverRouter) var serverRouter

                    await fireAndForget {
                        _ = try await sendEmail?(
                            Email(
                                business: .fromEnvVars,
                                passwordEmail: .change(.notification(.init(userName: currentUserName, userEmail: .init(email))))
                            )
                        )
                    }
                },
                sendEmailChangeConfirmation: { currentEmail, newEmail, token in
                    @Dependencies.Dependency(\.mailgun?.sendEmail) var sendEmail
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
                                            currentEmail: .init(currentEmail),
                                            newEmail: .init(newEmail),
                                            userName: currentUserName
                                        )
                                    )
                                )
                            )
                        )
                    }
                },
                sendEmailChangeRequestNotification: { currentEmail, newEmail in
                    @Dependencies.Dependency(\.mailgun?.sendEmail) var sendEmail
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
                                            currentEmail: .init(currentEmail),
                                            newEmail: .init(newEmail),
                                            userName: currentUserName
                                        )
                                    )
                                )
                            )
                        )
                    }
                },
                onEmailChangeSuccess: { currentEmail, newEmail in
                    @Dependencies.Dependency(\.mailgun?.sendEmail) var sendEmail
                    @Dependencies.Dependency(\.fireAndForget) var fireAndForget
                    @Dependencies.Dependency(\.currentUser?.name) var currentUserName
                    @Dependencies.Dependency(\.currentUser?.stripe?.customerId) var stripeCustomerId
                    @Dependencies.Dependency(\.serverRouter) var serverRouter
                    @Dependencies.Dependency(\.stripe) var stripe
                    @Dependencies.Dependency(\.logger) var logger

                    await fireAndForget {
                        do {
                            guard let identity = try await Identity.query(on: database)
                                .filter(\.$email == newEmail)
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
                                email: newEmail
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
                                                        currentEmail: .init(currentEmail),
                                                        newEmail: .init(newEmail),
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
                                                        currentEmail: .init(currentEmail),
                                                        newEmail: .init(newEmail),
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
            stripe: stripeClient.map(ServerDatabase.Client.Stripe.live(stripeClient:))
        )
    }
}

extension BusinessDetails {
    public static let fromEnvVars: BusinessDetails = {
        @Dependency(\.envVars.mailgun?.domain) var domain

        @Dependencies.Dependency(\.envVars.companyName!) var businessName
        @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var supportEmail
        @Dependencies.Dependency(\.envVars.companyInfoEmailAddress!) var fromEmail

        return BusinessDetails(
            name: businessName,
            supportEmail: supportEmail,
            fromEmail: "\(businessName) <postmaster@\(domain!)>",
            primaryColor: .green550.withDarkColor(.green600)
        )
    }()
}
