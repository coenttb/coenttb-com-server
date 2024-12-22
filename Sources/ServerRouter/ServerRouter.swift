import CasePaths
@_exported @preconcurrency import CoenttbServerRouter
import Dependencies
import Foundation
import Languages
@preconcurrency import URLRouting

public typealias ServerRouter = ServerRoute.Router<
    API.Router,
    Webhook.Router,
    WebsitePage.Router,
    Public.Router
>

public enum ServerRouterKey: TestDependencyKey {
    public static let testValue: ServerRouter = {
        @Dependency(\.envVars) var envVars
        return ServerRouter(
            baseURL: envVars.baseUrl,
            apiRouter: API.Router.shared,
            webhookRouter: Webhook.Router.shared,
            publicRouter: Public.Router.shared,
            pageRouter: WebsitePage.Router.shared
        )
    }()
}

extension DependencyValues {
    public var serverRouter: ServerRouter {
        get { self[ServerRouterKey.self] }
        set { self[ServerRouterKey.self] = newValue }
    }
}
