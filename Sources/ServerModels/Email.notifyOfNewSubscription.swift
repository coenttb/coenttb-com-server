//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 04/09/2024.
//

import CoenttbWeb
import Mailgun
import ServerEnvVars

extension Email {
    public static func notifyOfNewSubscription(
        companyName: String,
        to: EmailAddress,
        companyEmail: EmailAddress,
        subscriberEmail: EmailAddress,
        domain: String
    ) -> Email {
        
        @Dependencies.Dependency(\.envVars.appEnv) var appEnv

        return Mailgun.Email.notifyOfNewSubscription(
            from: companyEmail,
            to: to,
            subscriberEmail: subscriberEmail,
            companyEmail: companyEmail,
            companyName: companyName
        )
    }
}

extension Email {
    public static func notifyOfNewSubscription(
        from: EmailAddress,
        to: EmailAddress,
        subscriberEmail: EmailAddress,
        companyEmail: EmailAddress,
        companyName: String
    ) -> Email {
        return Email(
            from: companyEmail,
            to: [to],
            subject: "\(companyName) new subscriber: \(subscriberEmail)",
            html: nil,
            text: "\(subscriberEmail)"
        )
    }
}

extension Email {
    public static func notifyOfNewSubscription(
        from: EmailAddress,
        subscriberEmail: EmailAddress,
        companyEmail: EmailAddress,
        companyName: String
    ) -> Email {
        return Email.notifyOfNewSubscription(
            from: from,
            to: from,
            subscriberEmail: subscriberEmail,
            companyEmail: companyEmail,
            companyName: companyName
        )
    }
}


//
//extension Email {
//    public static func notifyOfNewSubscription(
//        from: String,
//        subscriberEmail: String
//    ) -> Email? {
//        @Dependency(\.envVars.appEnv) var appEnv
//        @Dependency(\.envVars.mailgun?.domain) var domain
//        @Dependency(\.envVars) var envVars
//
//        guard
//            let domain = domain,
//            let companyEmailString = envVars.companyInfoEmailAddress,
//            let companyName = envVars.companyName
//        else {
//            return nil
//        }
//
//        return Email.notifyOfNewSubscription(
//            companyName: companyName,
//            companyEmail: .init(companyEmailString),
//            subscriberEmail: subscriberEmail,
//            domain: domain.rawValue
//        )
//    }
//}
