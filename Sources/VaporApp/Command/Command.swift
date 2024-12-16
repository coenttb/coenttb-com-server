//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 06-01-2024.
//

import Foundation
import Vapor

struct RunMigrationsCommand: AsyncCommand {
    struct Signature: CommandSignature { }

    var help: String {
        "Says hello"
    }

    func run(using context: CommandContext, signature: Signature) async throws {
//        context.console.print("Hello, world!")
        let name = context.console.ask("What is your \("name", color: .green)?")
        context.console.print("Hello, \(name) 👋")
    }
}
