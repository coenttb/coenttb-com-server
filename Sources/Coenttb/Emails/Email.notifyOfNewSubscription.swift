//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 04/09/2024.
//

import Dependencies
import EmailAddress
import EnvVars
import Foundation
import Mailgun
import Tagged

extension Email {
    public static func notifyOfNewSubscription(
        from: EmailAddress,
        subscriberEmail: EmailAddress
    ) -> Email? {
        @Dependency(\.envVars.appEnv) var appEnv
        @Dependency(\.envVars.mailgun?.domain) var domain
        @Dependency(\.envVars) var envVars

        guard
            let domain = domain,
            let companyEmailString = envVars.companyInfoEmailAddress,
            let companyName = envVars.companyName
        else {
            return nil
        }

        return Email.notifyOfNewSubscription(
            companyName: companyName,
            companyEmail: .init(companyEmailString),
            subscriberEmail: subscriberEmail,
            domain: domain.rawValue
        )
    }
}
