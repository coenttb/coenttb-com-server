//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 17-12-2023.
//

import CoenttbWebHTML
import CoenttbWebStripe
import Dependencies
import Fluent
import Foundation
import HttpPipeline
import Languages
import Prelude
import ServerDependencies
import Vapor

extension CoenttbWebStripe.Client {
    static func webhook(
        request: Vapor.Request
    ) async throws -> any AsyncResponseEncodable {

        @Dependency(\.envVars.stripe?.endpointSecret) var stripeEndpointSecret
        guard let stripeEndpointSecret
        else {
            return Response.ok
        }

        @Dependency(\.request) var request
        guard let request else { throw RequestError(18) }

        @Dependency(\.stripe) var stripe
        guard let stripe else { throw Abort(.internalServerError) }

        let event = try StripeKit.Event(from: request, endpointSecret: stripeEndpointSecret)

        @Dependency(\.inMemoryStore) var inMemoryStore
        @Dependency(\.logger) var logger: Logger

        if let idempotencyKey = event.request?.idempotencyKey,
           await inMemoryStore.hasProcessedEvent(idempotencyKey: idempotencyKey, eventId: event.id) {
            logger.log(.notice, "true == inMemoryStore.hasProcessedEvent(idempotencyKey: \(idempotencyKey)")
            return Response.ok
        }

#if DEBUG
        logger.log(.info, "\(String.summarize(event: event))")
#endif

        @Dependency(\.envVars.stripe?.secretKey) var secretKey
        @Dependency(\.currentUser) var currentUser
        @Dependency(\.database) var database
        @Dependency(\.database.account) var account

        switch (event.type, event.data?.object) {
        case (
            .customerSubscriptionCreated,
            .subscription(let subscription)
        ):
            if var cu = currentUser {
                cu.stripe?.subscriptionStatus = subscription.status
                _ = try await account.update(cu)
            }
        case
            (.customerSubscriptionUpdated, .subscription(let subscription)):
            if var cu = currentUser {

                if let customerId = subscription.customer {
                    cu.stripe?.customerId = customerId
                }

                cu.stripe?.subscriptionStatus = subscription.status

                _ = try await account.update(cu)
            }
        case (.customerSubscriptionDeleted, .subscription(_)):
            if var cu = currentUser {
                cu.stripe = nil

                _ = try await account.update(cu)
            }
        case (.customerSubscriptionTrialWillEnd, .subscription(_)):
            break
        case
            (.customerCreated, .customer(let customer)):
            if var cu = currentUser {
                cu.stripe = .init(customerId: customer.id, subscriptionStatus: nil)
            }
        case (.customerUpdated, .customer(let customer)):
            if var cu = currentUser {
                cu.stripe?.customerId = customer.id
                _ = try await account.update(cu)
            }
        case (.customerDeleted, .customer(let customer)):
            do {
                _ = try await database.deleteCustomerIdFromUser(stripeCustomerId: customer.id)

            } catch {
                logger.log(.warning, "Stripe Webhook received .customerDeleted, but couldn't find User with that CoenttbWebStripe.customerId. This suggests that the synchronization between Stripe and the Database is not working correctly.")
                throw Abort(.internalServerError, reason: "Unknown customer id")
            }
        case (.paymentMethodAttached, .paymentMethod(_)):
            break
        case (.paymentMethodUpdated, .paymentMethod(_)):
            break
        case (.invoicePaymentFailed, .invoice(_)):
            break
        case (.invoicePaymentSucceeded, .invoice(let invoice)):
            if
                invoice.billingReason == .subscriptionCreate,
                let subscriptionId = invoice.subscription,
                let paymentIntentId = invoice.paymentIntent {

                @Dependency(\.envVars.stripe?.secretKey) var clientSecret

                do {
                    let paymentIntent = try await stripe.paymentIntents.retrieve(intent: paymentIntentId, clientSecret: clientSecret)

                    if let paymentMethodId = paymentIntent.paymentMethod {
                        _ = try await stripe.subscriptions.update(
                            subscription: subscriptionId,
                            defaultPaymentMethod: paymentMethodId
                        )
                        logger.info("Default payment method set for subscription: \(paymentMethodId)")
                    }
                } catch let error as StripeKit.StripeError {
                    let errorMessage: String
                    if let stripeError = error.error {
                        errorMessage = stripeError.message ?? "Unknown Stripe error"
                    } else {
                        errorMessage = "Stripe error without details"
                    }
                    logger.error("Failed to update the default payment method for subscription: \(subscriptionId). Error: \(errorMessage)")
                    return ["status": "error", "message": errorMessage]
                } catch {
                    let errorMessage = error.localizedDescription
                    logger.error("Unexpected error while updating the default payment method for subscription: \(subscriptionId). Error: \(errorMessage)")
                    return ["status": "error", "message": "An unexpected error occurred"]
                }
            }

        case (.paymentIntentCreated, .paymentIntent(_)):
            break
        case (.paymentIntentSucceeded, .paymentIntent(_)):
            break
        case (.chargeSucceeded, .charge(_)):
            break
        default:
            break
        }

        if let idempotencyKey = event.request?.idempotencyKey {
            await inMemoryStore.markEventAsProcessed(idempotencyKey: idempotencyKey, eventId: event.id)
        }

        return Response.ok

    }
}
