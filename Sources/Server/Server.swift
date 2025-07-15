import Coenttb_Vapor
import Vapor_Application

@main
struct Server {
    static func main() async throws {
#if DEBUG
        prepareDependencies {
            $0.coenttb = .testValue
        }
#endif
        
        @Dependency(\.envVars) var envVars
        
        let environment: Environment = .init(envVarsEnvironment: envVars.appEnv)
        let logLevel = envVars.logLevel ?? .info

//        LoggingSystem.bootstrap { CoenttbLogHandler(label: $0, logLevel: logLevel, metadataProvider: nil) }

        @Dependency(\.logger) var logger

        do {
            @Dependency(\.mainEventLoopGroup) var mainEventLoopGroup
            let application = try await Vapor.Application.make(environment, .shared(mainEventLoopGroup))
            defer { Task { try? await application.asyncShutdown() } }

            do {
                try await Application.main(
                    application: application,
                    environment: environment,
                    logLevel: logLevel,
                    configure: Application.configure
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
