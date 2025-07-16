//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 12/03/2025.
//
//
// import Coenttb_Server
// import Server_Dependencies
// import Server_Models
// import Coenttb_Com_Shared
//
// #if canImport(FoundationNetworking)
// import FoundationNetworking
// #endif
//
// extension StripeClientKey: @retroactive DependencyKey {
//    public static var liveValue: Coenttb_Stripe.Client? {
//        @Dependency(\.envVars) var envVars
//        @Dependency(\.httpClient) var httpClient
//
//        guard
//            let stripeSecretKey = envVars.stripe?.secretKey
//        else {
//            return nil
//        }
//
//        return Coenttb_Stripe.Client.live(
//            stripeSecretKey: stripeSecretKey,
//            httpClient: httpClient
//        )
//    }
// }
