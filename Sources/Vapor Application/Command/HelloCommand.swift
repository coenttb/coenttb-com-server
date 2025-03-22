//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 06-01-2024.
//

import Coenttb_Newsletter
import Dependencies
import EmailAddress
import Fluent
import Foundation
import Coenttb_Vapor

struct HelloCommand: AsyncCommand {
    struct Signature: CommandSignature { }

    var help: String {
        "Says hello"
    }

    func run(using context: CommandContext, signature: Signature) async throws {
        let name = context.console.ask("What is your \("name", color: .green)?")
        context.console.print("Hello, \(name) 👋")
    }
}
