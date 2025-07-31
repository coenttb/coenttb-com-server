import Coenttb_Vapor
import Vapor_Application
import Coenttb_Com_Router


@main
struct Server {
    static func main() async throws {
        
        prepareDependencies {
            $0.envVars =  try! EnvVars.live(
                localEnvFile: {
                    @Dependency(\.projectRoot) var projectRoot
                    let envFile = projectRoot.appendingPathComponent(".env.development")
                    print("envFile.path", envFile.path)
                    return FileManager.default.fileExists(atPath: envFile.path) ? envFile : nil
                }()
            )
        }
        
        prepareDependencies {
            $0.color = .coenttb
            
            if $0.envVars.appEnv == .development {
                $0.coenttb = .testValue
            }
        }
        
        @Dependency(\.coenttb.website.router) var router
        
        try await Vapor.Application.execute(
            router: router,
            use: Route.response,
            configure: Vapor.Application.configure
        )
    }
}
