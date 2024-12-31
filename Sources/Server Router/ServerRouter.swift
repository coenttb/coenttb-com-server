import Coenttb_Web
import Coenttb_Server_EnvVars
import Coenttb_Server_Router

public typealias ServerRouter = ServerRoute.Router<
    API.Router,
    Webhook.Router,
    WebsitePage.Router,
    Public.Router
>

public enum Server_RouterKey: TestDependencyKey {
    public static let testValue: ServerRouter = {
        withDependencies {
            $0.envVars = try! .live(localDevelopment: .projectRoot.appendingPathComponent(".env.development"))
        } operation: {
            @Dependency(\.envVars) var envVars
            return ServerRouter(
                baseURL: envVars.baseUrl,
                apiRouter: API.Router.shared,
                webhookRouter: Webhook.Router.shared,
                publicRouter: Public.Router.shared,
                pageRouter: WebsitePage.Router.shared
            )
        }
    }()
}

extension URL {
    fileprivate static var projectRoot: URL {
        return .init(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}

extension DependencyValues {
    public var serverRouter: ServerRouter {
        get { self[Server_RouterKey.self] }
        set { self[Server_RouterKey.self] = newValue }
    }
}
