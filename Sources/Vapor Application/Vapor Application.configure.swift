import Server_Application
import Coenttb_Server
import Server_EnvVars
import Fluent
import FluentPostgresDriver
import Queues
import QueuesFluentDriver
import Server_Client
import Server_Models
import Coenttb_Com_Shared
import Coenttb_Com_Router
import Coenttb_Vapor
import Coenttb_Identity_Consumer
import JWT

extension Application {
    package static func configure(app: Vapor.Application) async throws {

        // necessary to set here because $0.color has a liveValue default
        prepareDependencies {
            $0.color = .coenttb
        }
        
        Application.preloadStaticResources()

        @Dependency(\.envVars) var envVars

        app.environment = .init(envVarsEnvironment: envVars.appEnv)

        app.databases.use(.postgres, as: .psql )

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
        
        try await app.jwt.keys.add(ecdsa: ES256PublicKey(pem: envVars["JWT_PUBLIC_KEY"]!))
        
        app.middleware.use(Identity.Consumer.Middleware())

        @Dependency(\.coenttb.website.router) var router
        
        app.mount(router, use: Route.response)
    }
}

extension Application {
    static func preloadStaticResources() {
        _ = Clauses.privacyStatement
        _ = Clauses.generalTermsAndConditions
        _ = Clauses.termsOfUse
    }
}
