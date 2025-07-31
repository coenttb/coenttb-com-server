import Coenttb_Com_Router
import Coenttb_Com_Shared
import Coenttb_Server
import Coenttb_Vapor
import Fluent
import FluentPostgresDriver
import Queues
import QueuesFluentDriver
import Server_Client
import Server_EnvVars
import Server_Integration
import Server_Models

extension Vapor.Application {
    package static func configure(_ app: Vapor.Application) async throws {
        
        Vapor.Application.preloadStaticResources()

        @Dependency(\.envVars) var envVars

        app.environment = .init(envVarsEnvironment: envVars.appEnv)

        app.databases.use(.postgres, as: .psql )

        [any Migration].allCases.forEach { app.migrations.add($0) }

//            [any AsyncCommand].allCases.forEach { app.asyncCommands.use($0.0, as: $0.1) }

        app.migrations.add(JobMetadataMigrate())

        if envVars.appEnv == .development {
            try await app.autoRevert()
        }

        try await app.autoMigrate()

        app.queues.use(.fluent())
        try app.queues.startInProcessJobs(on: .default)
    }
}

extension Vapor.Application {
    package static func preloadStaticResources() {
        _ = Clauses.privacyStatement
        _ = Clauses.generalTermsAndConditions
        _ = Clauses.termsOfUse
    }
}
