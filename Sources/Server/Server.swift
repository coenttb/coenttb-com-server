import CoenttbVapor
import Dependencies
import Foundation
import Logging
import VaporApp

@main
struct Server {
    static func main() async throws {
        @Dependency(\.envVars) var envVars
        @Dependency(\.mainEventLoopGroup) var mainEventLoopGroup

        let environment: Environment = .init(envVarsEnvironment: envVars.appEnv)
        let logLevel = envVars.logLevel ?? .trace
        let configure: @Sendable (Application) async throws -> Void = Application.configure

        LoggingSystem.bootstrap { _ in
            CoenttbLogHandler(label: "main", logLevel: logLevel, metadataProvider: nil)
        }

        let application = try await Vapor.Application.make(environment, .shared(mainEventLoopGroup))

        try await CoenttbVapor.Application.main(
            application: application,
            environment: environment,
            logLevel: logLevel,
            configure: configure
        )
    }
}
