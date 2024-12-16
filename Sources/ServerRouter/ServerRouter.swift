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
    public static var testValue: ServerRouter {fatalError()}
}

extension DependencyValues {
    public var serverRouter: ServerRouter {
        get { self[ServerRouterKey.self] }
        set { self[ServerRouterKey.self] = newValue }
    }
}
