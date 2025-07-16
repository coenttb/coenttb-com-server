//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 18/12/2024.
//

import Coenttb_Vapor
import Foundation

extension [any AsyncCommand] {
    static var allCases: [(any AsyncCommand, String)] {
        [
            (
                HelloCommand(),
                "hello"
            ),
            (
                ResendVerificationEmailsCommand(),
                "resend-verification-emails"
            ),
            (
                GetMailingListCommand(),
                "get-coenttb-mailing-list"
            )
        ]
    }
}
