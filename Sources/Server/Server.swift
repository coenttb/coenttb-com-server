import Boiler
import Coenttb_Com_Router
import Coenttb_Vapor
import Vapor_Application

@main
struct Server {
    static func main() async throws {
        prepareDependencies {
//            $0.envVars = try! EnvVars.live(localEnvFile: .localEnvFile)

            if $0.envVars.appEnv == .development {
                $0.coenttb = .testValue
            }

            $0.color = .coenttb
        }

        @Dependency(\.coenttb.website.router) var router

        try await Boiler.execute(
            router: router,
            use: { route in
                return try await withDependencies {
                    $0.envVars = try EnvVars.live(localEnvFile: .localEnvFile)
                } operation: {
                    @Dependency(\.envVars.emergencyMode) var emergencyMode
                    guard !emergencyMode else { return "emergency mode" }
                    return try await Route.response(route: route)
                }
            },
            configure: Vapor.Application.configure
        )
    }
}

extension URL? {
    static var localEnvFile: Self {
        @Dependency(\.projectRoot) var projectRoot
        let envFile = projectRoot.appendingPathComponent(".env.development")
        let fileExists = FileManager.default.fileExists(atPath: envFile.path())
        return fileExists ? envFile : nil
    }
}
