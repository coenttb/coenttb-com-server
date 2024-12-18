//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 06-01-2024.
//

import Foundation
import Vapor
import CoenttbWebNewsletter
import ServerDatabase
import Vapor
import Fluent
import Dependencies
import EmailAddress



struct HelloCommand: AsyncCommand {
    struct Signature: CommandSignature { }

    var help: String {
        "Says hello"
    }

    func run(using context: CommandContext, signature: Signature) async throws {
        let name = context.console.ask("What is your \("name", color: .green)?")
        context.console.print("Hello, \(name) 👋")
    }
}


import Vapor
import Fluent
import Dependencies
import EmailAddress
import CoenttbWebNewsletter

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
    
    func run(using context: CommandContext, signature: Signature) async throws {
        let batchSize = signature.batchSize ?? 50
        let delayMs = signature.delayMs ?? 500 // Default 500ms delay
        
        context.console.info("Starting to process unverified newsletter subscriptions...")
        
        // Get all unverified subscriptions
        let unverifiedSubscriptions = try await Newsletter.query(on: context.application.db)
            .filter(\.$emailVerificationStatus == .unverified)
            .all()
        
        context.console.info("Found \(unverifiedSubscriptions.count) unverified subscriptions")
        
        var successCount = 0
        var failureCount = 0
        
        // Process in batches
        for batch in unverifiedSubscriptions.chunks(ofCount: batchSize) {
            for subscription in batch {
                do {
                    // Check token generation limit
                    guard try await subscription.canGenerateToken(on: context.application.db) else {
                        context.console.warning("Token generation limit exceeded for email: \(subscription.email)")
                        failureCount += 1
                        continue
                    }
                    
                    // Generate new verification token
                    let verificationToken = try subscription.generateToken(
                        type: .emailVerification,
                        validUntil: Date().addingTimeInterval(24 * 60 * 60) // 24 hours
                    )
                    try await verificationToken.save(on: context.application.db)
                    
                    // Update status to pending
                    subscription.emailVerificationStatus = .pending
                    try await subscription.save(on: context.application.db)
                    
                    // Send verification email using the static client function
                    try await CoenttbWebNewsletter.Client.sendVerificationEmail(
                        email: subscription.email,
                        token: verificationToken.value
                    )
                    
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
            
            // Progress update after each batch
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
