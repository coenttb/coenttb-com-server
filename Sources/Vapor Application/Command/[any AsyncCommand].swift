//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 18/12/2024.
//

import ServerFoundationVapor
import Foundation

extension [any AsyncCommand] {
    static var allCases: [String: (any AsyncCommand)] {
        .init {
            ("hello", HelloCommand())
            ("resend-verification-emails", ResendVerificationEmailsCommand())
            ("get-mailing-list", GetMailingListCommand())
        }
    }
}
