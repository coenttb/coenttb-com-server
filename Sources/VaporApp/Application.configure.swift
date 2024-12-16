import Coenttb
import CoenttbVapor
import CoenttbWebHTML
import Dependencies
import EnvVars
import Fluent
import FluentPostgresDriver
import Queues
import QueuesFluentDriver
import ServerDatabase
import ServerModels
import ServerRouter
import Vapor
import VaporRouting

extension Application {
    public static func configure(app: Application) async throws {

        Application.preloadStaticResources()

        @Dependency(\.serverRouter) var serverRouter
        @Dependency(\.sqlConfiguration) var sqlConfiguration
        @Dependency(\.envVars) var envVars

        app.environment = .init(envVarsEnvironment: envVars.appEnv)

        app.databases.use(.postgres(configuration: sqlConfiguration), as: .psql)

        [any Migration].coenttb.forEach { app.migrations.add($0) }

        app.migrations.add(JobMetadataMigrate())

        if envVars.appEnv == .development {
            try await app.autoRevert()
        }

        try await app.autoMigrate()

        app.queues.use(.fluent())
        try app.queues.startInProcessJobs(on: .default)

    
        
        try await CoenttbVapor.Application.configure(
            app: app,
            httpsRedirect: envVars.httpsRedirect,
            canonicalHost: envVars.canonicalHost,
            allowedInsecureHosts: envVars.allowedInsecureHosts,
            baseUrl: envVars.baseUrl
        )

        app.middleware.use(
            SessionsMiddleware.secure(
                driver: app.sessions.driver,
                cookieName: envVars.sessionCookieName ?? envVars.canonicalHost.map { "\($0)-session".replacingOccurrences(of: ".", with: "-") } ?? "default-session-id",
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
    public init(envVarsEnvironment: EnvVars.AppEnv) {
        self =
        switch envVarsEnvironment {
        case .development: .development
        case .production: .production
        case .staging: .staging
        case .testing: .testing
        }
    }
}
