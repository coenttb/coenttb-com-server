//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 12/03/2025.
//

import Coenttb_Com_Shared
import Coenttb_Server
import Mailgun
import Server_Client
import Server_Dependencies
import Server_Models

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.AuthenticatedClient? {
        @Dependency(\.envVars) var envVars

        guard
            let baseURL = envVars.mailgun?.baseUrl,
            let apiKey = envVars.mailgun?.apiKey,
            let domain = envVars.mailgun?.domain
        else {
            return nil
        }

        return Mailgun.Client.live(
            apiKey: apiKey,
            baseUrl: baseURL,
            domain: domain
        )
    }
}

extension Mailgun.Client {
    enum Error: Swift.Error {
        case clientIsNil
    }
}
