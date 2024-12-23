import CasePaths
@_exported @preconcurrency import CoenttbServerRouter
import Dependencies
import Foundation
import Languages
@preconcurrency import URLRouting

public typealias Server_Router = ServerRoute.Router<
    API.Router,
    Webhook.Router,
    WebsitePage.Router,
    Public.Router
>

public enum Server_RouterKey: TestDependencyKey {
    public static let testValue: Server_Router = {
        @Dependency(\.envVars) var envVars
        return Server_Router(
            baseURL: envVars.baseUrl,
            apiRouter: API.Router.shared,
            webhookRouter: Webhook.Router.shared,
            publicRouter: Public.Router.shared,
            pageRouter: WebsitePage.Router.shared
        )
    }()
}

extension DependencyValues {
    public var serverRouter: Server_Router {
        get { self[Server_RouterKey.self] }
        set { self[Server_RouterKey.self] = newValue }
    }
}
