//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 04/09/2024.
//

import Coenttb_Server
import Mailgun
import Server_EnvVars

extension Email {
    package static func notifyOfNewSubscription(
        companyName: String,
        to: EmailAddress,
        companyEmail: EmailAddress,
        subscriberEmail: EmailAddress,
        domain: String
    ) -> Email {
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
    package static func notifyOfNewSubscription(
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
    package static func notifyOfNewSubscription(
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
