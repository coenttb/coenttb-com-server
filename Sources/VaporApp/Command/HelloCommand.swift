//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 06-01-2024.
//

import Foundation
import Vapor
import CoenttbWebNewsletter
import ServerDatabase
import Vapor
import Fluent
import Dependencies
import EmailAddress



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
