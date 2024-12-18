//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 18/12/2024.
//

import Foundation
import Vapor

extension [any AsyncCommand] {
    static var coenttb: [(any AsyncCommand, String)] {
        [
            (HelloCommand(), "hello"),
            (ResendVerificationEmailsCommand(), "resend-verification-emails"),
        ]
    }
}
