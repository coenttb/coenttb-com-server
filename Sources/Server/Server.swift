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
        let logLevel = envVars.logLevel ?? .info
        
        LoggingSystem.bootstrap { _ in
            CoenttbLogHandler(label: "main", logLevel: logLevel, metadataProvider: nil)
        }
        
        @Dependency(\.logger) var logger
        
        do {
            let application = try await Vapor.Application.make(environment, .shared(mainEventLoopGroup))
            defer { Task { try? await application.asyncShutdown() } }
            
            do {
                let configure: @Sendable (Application) async throws -> Void = Application.configure
                
                try await CoenttbVapor.Application.main(
                    application: application,
                    environment: environment,
                    logLevel: logLevel,
                    configure: configure
                )
            } catch {
                logger.critical("Application failed to start: \(error.localizedDescription)")
                throw error
            }
            
        } catch {
            logger.critical("Critical failure: \(error.localizedDescription)")
            throw error
        }
    }
}
