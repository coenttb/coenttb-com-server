import Coenttb_Web
import Coenttb_Server

@_exported @preconcurrency import Coenttb_Server_Router
@preconcurrency import URLRouting

public typealias Server_Router = ServerRoute.Router<
    API.Router,
    Webhook.Router,
    WebsitePage.Router,
    Public.Router
>

public enum Server_RouterKey: TestDependencyKey {
    public static let testValue: Server_Router = {
        withDependencies {
            $0.envVars = try! .live(localDevelopment: .projectRoot.appendingPathComponent(".env.development"))
        } operation: {
            @Dependency(\.envVars) var envVars
            return Server_Router(
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
    static var projectRoot: URL {
        return .init(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}

extension DependencyValues {
    public var serverRouter: Server_Router {
        get { self[Server_RouterKey.self] }
        set { self[Server_RouterKey.self] = newValue }
    }
}
