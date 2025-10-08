import CoenttbRouter
import CoenttbShared
import Coenttb_Server
import ServerFoundationVapor
import Fluent
import FluentPostgresDriver
import Queues
import QueuesFluentDriver
import Server_Client
import Server_EnvVars
import Server_Integration
import Server_Models

extension Vapor.Application {
    package static func configure(_ application: Vapor.Application) async throws {

        Vapor.Application.preloadStaticResources()

        @Dependency(\.envVars) var envVars

        application.environment = .init(envVarsEnvironment: envVars.appEnv)

        application.databases.use(.postgres, as: .psql )

        [any Migration].allCases.forEach { application.migrations.add($0) }

        [any AsyncCommand].allCases.forEach { application.asyncCommands.use($0.1, as: $0.0) }

        application.migrations.add(JobMetadataMigrate())

        if envVars.appEnv == .development {
            try await application.autoRevert()
        }

        try await application.autoMigrate()

        application.queues.use(.fluent())
        try application.queues.startInProcessJobs(on: .default)
    }
}

extension Vapor.Application {
    package static func preloadStaticResources() {
        _ = Clauses.privacyStatement
        _ = Clauses.generalTermsAndConditions
        _ = Clauses.termsOfUse
    }
}
