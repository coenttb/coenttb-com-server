//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 18/12/2024.
//

import Coenttb_Newsletter
// TODO: Migrate from Fluent to swift-records
// import Coenttb_Newsletter_Fluent
import ServerFoundationVapor
import Dependencies
import EmailAddress
import Fluent
import Mailgun

struct GetMailingListCommand: AsyncCommand {
    struct Signature: CommandSignature {
        @Vapor.Option(name: "delay", short: "d", help: "Delay in milliseconds between each email")
        var delayMs: Int?

        init() { }
    }

    var help: String {
        "Resends verification emails to all unverified newsletter subscribers"
    }

    @Dependency(\.mailgun.client.mailingLists.get) var getList

    func run(using context: CommandContext, signature: Signature) async throws {
        await withDependencies {
            $0.databaseConfiguration.connectionPoolTimeout = .seconds(30)
            $0.databaseConfiguration.maxConnectionsPerEventLoop = 1
        } operation: {
            context.console.info("Starting to process get Lists...")

            do {
                let response = try await getList(try .init("coen@mg.coenttb.com"))

                if let description = response.list.description {
                    context.console.success(description)
                }
            } catch {
                context.console.error(error.localizedDescription)
            }
        }
    }
}
