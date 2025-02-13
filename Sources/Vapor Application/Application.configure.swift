import Coenttb
import Coenttb_Server
import Coenttb_Identity_Live
import Coenttb_Identity_Fluent
import Server_EnvVars
import Fluent
import FluentPostgresDriver
import Queues
import QueuesFluentDriver
import Server_Client
import Server_Client_Live
import Server_Models
import Server_Router
import Coenttb_Vapor

extension Application {
    package static func configure(app: Vapor.Application) async throws {

        Application.preloadStaticResources()

        @Dependency(\.serverRouter) var serverRouter
        @Dependency(\.sqlConfiguration) var sqlConfiguration
        @Dependency(\.envVars) var envVars
        @Dependency(\.logger) var logger
        @Dependency(\.databaseConfiguration) var databaseConfiguration

        app.environment = .init(envVarsEnvironment: envVars.appEnv)

        app.databases.use(
            .postgres(
                configuration: sqlConfiguration,
                maxConnectionsPerEventLoop: databaseConfiguration.maxConnectionsPerEventLoop,
                connectionPoolTimeout: databaseConfiguration.connectionPoolTimeout
            ),
            as: .psql
        )

        [any Migration].allCases.forEach { app.migrations.add($0) }

        [any AsyncCommand].allCases.forEach { app.asyncCommands.use($0.0, as: $0.1) }

        app.migrations.add(JobMetadataMigrate())

        if envVars.appEnv == .development {
            try await app.autoRevert()
        }

        try await app.autoMigrate()

        app.queues.use(.fluent())
        try app.queues.startInProcessJobs(on: .default)

        try await Coenttb_Vapor.Application.configure(
            app: app,
            httpsRedirect: envVars.httpsRedirect,
            canonicalHost: envVars.canonicalHost,
            allowedInsecureHosts: envVars.allowedInsecureHosts,
            baseUrl: envVars.baseUrl
        )

        app.middleware.use(
            SessionsMiddleware.secure(
                driver: app.sessions.driver,
                cookieName: envVars.sessionCookieName
                ?? envVars.canonicalHost.map { "\($0)-session".replacingOccurrences(of: ".", with: "-") }
                ?? "default-session-id",
                isSecure: envVars.appEnv == .production || envVars.appEnv == .staging ? true : false
            )
        )

        app.middleware.use(Identity.SessionAuthenticator())

        switch envVars.appEnv {
        case .development: app.sessions.use(.memory)
        case .testing: app.sessions.use(.memory)
        case .staging: app.sessions.use(.fluent)
        case .production: app.sessions.use(.fluent)
        }

        app.queues.schedule(ConfirmDeleteUserJob())
            .daily()
            .at(.midnight)

        app.mount(serverRouter, use: ServerRoute.response)
    }
}

extension Application {
    static func preloadStaticResources() {
        _ = Clauses.privacyStatement
        _ = Clauses.generalTermsAndConditions
        _ = Clauses.termsOfUse
    }
}

extension Vapor.Environment {
    package init(envVarsEnvironment: EnvVars.AppEnv) {
        self =
        switch envVarsEnvironment {
        case .development: .development
        case .production: .production
        case .staging: .staging
        case .testing: .testing
        }
    }
}
