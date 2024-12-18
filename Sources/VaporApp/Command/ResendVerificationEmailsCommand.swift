//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 18/12/2024.
//

import Vapor
import Fluent
import Dependencies
import EmailAddress
import CoenttbWebNewsletter
import Mailgun

struct ResendVerificationEmailsCommand: AsyncCommand {
    struct Signature: CommandSignature {
        @Option(name: "batch-size", short: "b", help: "Number of emails to process in each batch")
        var batchSize: Int?
        
        @Option(name: "delay", short: "d", help: "Delay in milliseconds between each email")
        var delayMs: Int?
        
        init() { }
    }
    
    var help: String {
        "Resends verification emails to all unverified newsletter subscribers"
    }
    
    @Dependency(\.serverRouter) var serverRouter
    @Dependency(\.envVars.companyName) var companyName
    @Dependency(\.envVars.companyInfoEmailAddress) var supportEmail
    @Dependency(\.envVars.mailgun?.domain) var domain
    @Dependency(\.mailgun?.sendEmail) var sendEmail
    
    func run(using context: CommandContext, signature: Signature) async throws {
        // Get required dependencies from the application
        guard let sendEmail else {
            context.console.error("Mailgun configuration is missing")
            throw Abort(.internalServerError)
        }
        
        
        
        // Validate required environment variables
        guard let companyName = companyName,
              let supportEmail = supportEmail,
              let domain = domain else {
            context.console.error("Required environment variables are missing")
            throw Abort(.internalServerError)
        }
        
        let batchSize = signature.batchSize ?? 50
        let delayMs = signature.delayMs ?? 500
        
        context.console.info("Starting to process unverified newsletter subscriptions...")
        
        let unverifiedSubscriptions = try await Newsletter.query(on: context.application.db)
            .filter(\.$emailVerificationStatus == .unverified)
            .all()
        
        context.console.info("Found \(unverifiedSubscriptions.count) unverified subscriptions")
        
        var successCount = 0
        var failureCount = 0
        
        for batch in unverifiedSubscriptions.chunks(ofCount: batchSize) {
            for subscription in batch {
                do {
                    guard try await subscription.canGenerateToken(on: context.application.db) else {
                        context.console.warning("Token generation limit exceeded for email: \(subscription.email)")
                        failureCount += 1
                        continue
                    }
                    
                    let verificationToken = try subscription.generateToken(
                        type: .emailVerification,
                        validUntil: Date().addingTimeInterval(24 * 60 * 60)
                    )
                    try await verificationToken.save(on: context.application.db)
                    
                    subscription.emailVerificationStatus = .pending
                    try await subscription.save(on: context.application.db)
                    
                    // Use mailgun directly instead of the static client
                    let email = Email.requestEmailVerification(
                        verificationUrl: serverRouter.url(for: .newsletter(.subscribe(.verify(.init(token: verificationToken.value, email: subscription.email))))),
                        businessName: companyName,
                        supportEmail: supportEmail,
                        from: "\(companyName) <postmaster@\(domain.rawValue)>",
                        to: (name: nil, email: .init(subscription.email)),
                        primaryColor: .green550.withDarkColor(.green600)
                    )
                    
                    _ = try await sendEmail(email)
                    
                    successCount += 1
                    context.console.success("Successfully sent verification email to: \(subscription.email)")
                    
                    if delayMs > 0 {
                        try await Task.sleep(nanoseconds: UInt64(delayMs * 1_000_000))
                    }
                    
                } catch {
                    failureCount += 1
                    context.console.error("Failed to process email \(subscription.email): \(error)")
                }
            }
            
            context.console.info("""
                Progress:
                - Processed: \(successCount + failureCount)
                - Remaining: \(unverifiedSubscriptions.count - (successCount + failureCount))
                - Success rate: \(Double(successCount) / Double(successCount + failureCount) * 100)%
                """)
        }
        
        context.console.success("""
            Verification email resend completed:
            - Total processed: \(unverifiedSubscriptions.count)
            - Successful: \(successCount)
            - Failed: \(failureCount)
            """)
    }
}
