//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 31/08/2024.
//

import Dependencies
import EmailAddress
import EnvVars
import Foundation
import Languages
import Mailgun
import Tagged

extension Email {
    public static func generalContact(
        from: EmailAddress = "",
        domain: String = ""
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
        let to: EmailAddress = .init(envVars.companyInfoEmailAddress!)

        return .init(
            from: from,
            to: [to],
            subject: subject?.description ?? "",
            text: body.description,
            html: nil,
            domain: domain
        )
    }
}
