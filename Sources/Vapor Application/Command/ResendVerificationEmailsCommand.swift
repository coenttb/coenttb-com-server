//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 18/12/2024.
//

import Coenttb_Newsletter
import Coenttb_Newsletter_Fluent
import Coenttb_Vapor
import Dependencies
import EmailAddress
import Fluent
import Mailgun

struct ResendVerificationEmailsCommand: AsyncCommand {
    struct Signature: CommandSignature {
        @Vapor.Option(name: "delay", short: "d", help: "Delay in milliseconds between each email")
        var delayMs: Int?

        init() { }
    }

    var help: String {
        "Resends verification emails to all unverified newsletter subscribers"
    }

    @Dependency(\.coenttb.website.router) var router
    @Dependency(\.envVars.companyName) var companyName
    @Dependency(\.envVars.companyInfoEmailAddress) var supportEmail
    @Dependency(\.envVars.mailgun?.domain) var domain
    @Dependency(\.mailgunClient?.messages.send) var sendEmail

    func run(using context: CommandContext, signature: Signature) async throws {
        fatalError()
//        try await withDependencies {
//            $0.databaseConfiguration.connectionPoolTimeout = .seconds(30)
//            $0.databaseConfiguration.maxConnectionsPerEventLoop = 1
//        } operation: {
//            // Get required dependencies from the application
//            guard let sendEmail else {
//                context.console.error("Mailgun configuration is missing")
//                throw Abort(.internalServerError)
//            }
//
//            // Validate required environment variables
//            guard let companyName = companyName,
//                  let supportEmail = supportEmail,
//                  let domain = domain else {
//                context.console.error("Required environment variables are missing")
//                throw Abort(.internalServerError)
//            }
//
//            let delayMs = signature.delayMs ?? 10000 // Default 10 seconds between emails
//
//            context.console.info("Starting to process unverified newsletter subscriptions...")
//
//            // Get all unverified subscriptions in a single transaction
//            let unverifiedSubscriptions = try await context.application.db.transaction { db in
//                try await Newsletter.query(on: db)
//                    .filter(\.$emailVerificationStatus == .unverified)
//                    .all()
//            }
//
//            context.console.info("Found \(unverifiedSubscriptions.count) unverified subscriptions")
//
//            var successCount = 0
//            var failureCount = 0
//
//            // Process subscriptions one at a time
//            for subscription in unverifiedSubscriptions {
//                do {
//                    try await context.application.db.transaction { db in
//                        // Check token generation limit
//                        guard try await subscription.canGenerateToken(on: db) else {
//                            context.console.warning("Token generation limit exceeded for email: \(subscription.email)")
//                            throw Abort(.tooManyRequests)
//                        }
//
//                        // Generate new verification token
//                        let verificationToken = try subscription.generateToken(
//                            type: .emailVerification,
//                            validUntil: Date().addingTimeInterval(24 * 60 * 60)
//                        )
//                        try await verificationToken.save(on: db)
//
//                        // Update status to pending
//                        subscription.emailVerificationStatus = .pending
//                        try await subscription.save(on: db)
//
//                        // Send verification email
//                        let email = try Email.requestEmailVerification(
//                            verificationUrl: router.url(for: .newsletter(.subscribe(.verify(.init(token: verificationToken.value, email: subscription.email))))),
//                            businessName: companyName,
//                            supportEmail: supportEmail,
//                            from: .init(displayName: companyName, localPart: "postmaster", domain: domain.rawValue),
//                            to: (name: nil, email: .init(subscription.email)),
//                            primaryColor: .green550.withDarkColor(.green600)
//                        )
//
//                        _ = try await sendEmail(email)
//                    }
//
//                    successCount += 1
//                    context.console.success("Successfully sent verification email to: \(subscription.email)")
//
//                    // Add delay between processing emails
//                    if delayMs > 0 {
//                        try await Task.sleep(nanoseconds: UInt64(delayMs * 1_000_000))
//                    }
//
//                } catch {
//                    failureCount += 1
//                    context.console.error("""
//                        Failed to process email \(subscription.email):
//                        Error type: \(type(of: error))
//                        Detailed error: \(String(reflecting: error))
//                        Raw error: \(error)
//                        """)
//                }
//
//                // Show progress after each email
//                context.console.info("""
//                    Progress:
//                    - Processed: \(successCount + failureCount)
//                    - Remaining: \(unverifiedSubscriptions.count - (successCount + failureCount))
//                    - Success rate: \(Double(successCount) / Double(successCount + failureCount) * 100)%
//                    """)
//            }
//
//            context.console.success("""
//                Verification email resend completed:
//                - Total processed: \(unverifiedSubscriptions.count)
//                - Successful: \(successCount)
//                - Failed: \(failureCount)
//                """)
//        }
    }
}
