//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 31/08/2024.
//

import Dependencies
import EmailAddress
import Mailgun
import Server_EnvVars
import Translating

extension Mailgun.Email {
    package static func generalContact(
        from: EmailAddress
    ) -> Email {

        let subject = String?.none

        let body = TranslatedString(
            dutch: """
                Hey Coen,

                Alles goed? Ik stuur je even een bericht over...

                Thanks alvast voor je tijd.

                Groet,
                [Jouw Naam]
                [Jouw Bedrijf/Organisatie]
                [Jouw Contactgegevens]
                """,
            english: """
                Hey Coen,

                Hope you’re doing well! Just reaching out about...

                Thanks in advance for your time.

                Cheers,
                [Your Name]
                [Your Company/Organization]
                [Your Contact Information]
                """
        )

        @Dependency(\.envVars) var envVars
        let to: EmailAddress = envVars.companyInfoEmailAddress!

        return .init(
            from: from,
            to: [to],
            subject: subject?.description ?? "",
            html: nil,
            text: body.description
        )
    }
}
