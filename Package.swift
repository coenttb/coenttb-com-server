// swift-tools-version:6.0.0

import Foundation
import PackageDescription

extension String {
    static let coenttb: Self = "Coenttb"
    static let server: Self = "Server"
    static let serverClient: Self = "Server Client"
    static let serverClientLive: Self = "Server Client Live"
    static let serverDatabase: Self = "Server Database"
    static let serverDependencies: Self = "Server Dependencies"
    static let serverEnvVars: Self = "Server EnvVars"
    static let serverModels: Self = "Server Models"
    static let serverTranslations: Self = "Server Translations"
    static let vaporApp: Self = "Vapor Application"
}

extension Target.Dependency {
    static var coenttb: Self { .target(name: .coenttb) }
    static var serverClient: Self { .target(name: .serverClient) }
    static var serverClientLive: Self { .target(name: .serverClientLive) }
    static var serverDatabase: Self { .target(name: .serverDatabase) }
    static var serverEnvVars: Self { .target(name: .serverEnvVars) }
    static var serverDependencies: Self { .target(name: .serverDependencies) }
    static var serverModels: Self { .target(name: .serverModels) }
    static var serverTranslations: Self { .target(name: .serverTranslations) }
    static var vaporApp: Self { .target(name: .vaporApp) }
}

extension Target.Dependency {
    static var coenttbComShared: Self { .product(name: "Coenttb Com Shared", package: "coenttb-com-shared") }
    static var coenttbServer: Self { .product(name: "Coenttb Server", package: "coenttb-server") }
    static var coenttbServerVapor: Self { .product(name: "Coenttb Vapor", package: "coenttb-server-vapor") }
    static var coenttbServerFluent: Self { .product(name: "Coenttb Fluent", package: "coenttb-server-vapor") }
    static var coenttbBlog: Self { .product(name: "Coenttb Blog", package: "coenttb-blog") }
    static var coenttbBlogVapor: Self { .product(name: "Coenttb Blog Vapor", package: "coenttb-blog") }
    static var coenttbIdentityConsumer: Self { .product(name: "Coenttb Identity Consumer", package: "coenttb-identities") }
    static var coenttbNewsletter: Self { .product(name: "Coenttb Newsletter", package: "coenttb-newsletter") }
    static var coenttbNewsletterFluent: Self { .product(name: "Coenttb Newsletter Fluent", package: "coenttb-newsletter") }
    static var coenttbSyndication: Self { .product(name: "Coenttb Syndication", package: "coenttb-syndication") }
    static var coenttbSyndicationVapor: Self { .product(name: "Coenttb Syndication Vapor", package: "coenttb-syndication") }
    static var coenttbLegalDocuments: Self { .product(name: "Coenttb Legal Documents", package: "coenttb") }
    static var googleAnalytics: Self { .product(name: "GoogleAnalytics", package: "coenttb-google-analytics") }
    static var hotjar: Self { .product(name: "Hotjar", package: "coenttb-hotjar") }
    static var mailgun: Self { .product(name: "Mailgun", package: "coenttb-mailgun") }
    static var postgres: Self { .product(name: "Postgres", package: "coenttb-postgres") }
//    static var stripe: Self { .product(name: "Coenttb Stripe", package: "coenttb-stripe") }
//    static var stripeLive: Self { .product(name: "Coenttb Stripe Live", package: "coenttb-stripe") }

    static var queuesFluentDriver: Self { .product(name: "QueuesFluentDriver", package: "vapor-queues-fluent-driver") }
    static var dependenciesMacros: Self { .product(name: "DependenciesMacros", package: "swift-dependencies") }
    static var dependenciesTestSupport: Self { .product(name: "DependenciesTestSupport", package: "swift-dependencies") }
    static var vaporTesting: Self { .product(name: "VaporTesting", package: "vapor") }
}

let package = Package(
    name: "coenttb-com-server",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: .serverEnvVars, targets: [.serverEnvVars]),
        .library(name: .serverDependencies, targets: [.serverDependencies]),
        .library(name: .serverModels, targets: [.serverModels]),
        .library(name: .serverTranslations, targets: [.serverTranslations]),
        .library(name: .coenttb, targets: [.coenttb]),
        .library(name: .vaporApp, targets: [.vaporApp]),
        .library(name: .serverClient, targets: [.serverClient]),
        .library(name: .serverClientLive, targets: [.serverClientLive]),
        .library(name: .serverDatabase, targets: [.serverDatabase]),
        .executable(name: .server, targets: [.server])
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/coenttb.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-server.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-com-shared.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-server-vapor.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-blog.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-google-analytics.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-identities.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-newsletter.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-postgres.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-hotjar.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-mailgun.git", branch: "main"),
//        .package(url: "https://github.com/coenttb/coenttb-stripe.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-syndication.git", branch: "main"),
        .package(url: "https://github.com/m-barthelemy/vapor-queues-fluent-driver.git", from: "3.0.0-beta1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.6.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.110.2"),
        
        // TIP: Ensure that any non-public dependency of a dependency requiring authentication is explicitly listed here to enable successful linking on Heroku.
    ],
    targets: [
        .target(
            name: .coenttb,
            dependencies: [
                .serverEnvVars,
                .serverTranslations,
                .serverClientLive,
                .coenttbIdentityConsumer,
                .googleAnalytics,
                .hotjar,
                .mailgun,
                .coenttbLegalDocuments,
                .coenttbServer,
                .coenttbComShared,
//                .stripeLive,
            ],
            resources: [
                .process("Blog/Posts")
            ]
        ),
        .target(
            name: .serverClient,
            dependencies: [
                .serverEnvVars,
                .serverDependencies,
                .dependenciesMacros,
                .coenttbServer,
                .coenttbIdentityConsumer,
                .mailgun,
                .coenttbNewsletter,
                .coenttbComShared,
            ]
        ),
        .target(
            name: .serverClientLive,
            dependencies: [
                .serverClient,
                .serverDependencies,
                .serverDatabase,
                .serverEnvVars,
                .dependenciesMacros,
                .queuesFluentDriver,
                .coenttbServer,
                .coenttbIdentityConsumer,
                .coenttbNewsletter,
                .coenttbNewsletterFluent,
                .mailgun,
                .coenttbComShared,
            ]
        ),
        .target(
            name: .serverDatabase,
            dependencies: [
                .coenttbServer,
                .coenttbServerFluent,
                .coenttbIdentityConsumer,
                .coenttbNewsletterFluent,
                .serverDependencies,
                .serverEnvVars,
                .dependenciesMacros,
//                .stripe,
            ]
        ),
        .target(
            name: .serverDependencies,
            dependencies: [
                .coenttbServer,
                .serverModels,
                .coenttbComShared,
            ]
        ),
        .target(
            name: .serverEnvVars,
            dependencies: [
                .coenttbServer,
                .hotjar,
                .mailgun,
                .googleAnalytics,
                .postgres,
//                .stripe,
            ]
        ),
        .target(
            name: .serverModels,
            dependencies: [
                .serverEnvVars,
                .coenttbServer,
            ]
        ),
        .target(
            name: .serverTranslations,
            dependencies: [
                .coenttbServer,
            ]
        ),
        .target(
            name: .vaporApp,
            dependencies: [
                .coenttbServer,
                .coenttbServerVapor,
                .serverEnvVars,
                .serverClient,
                .serverDependencies,
                .coenttbServer,
                .coenttb,
                .coenttbNewsletter,
                .queuesFluentDriver,
                .coenttbSyndicationVapor,
                .coenttbBlogVapor,
                .coenttbComShared,
            ]
        ),
        .testTarget(
            name: .vaporApp.tests,
            dependencies: [
                .vaporApp,
                .coenttbServerVapor,
                .vaporTesting,
                .serverEnvVars,
                .serverClient,
                .serverDependencies,
                .coenttbServer,
                .coenttb,
                .coenttbNewsletter,
                .coenttbBlog,
                .queuesFluentDriver,
                .dependenciesTestSupport,
            ]
        ),
        .executableTarget(
            name: .server,
            dependencies: [
                .vaporApp,
                .coenttbServer,
            ]
        ),
        .testTarget(
            name: .coenttb.tests,
            dependencies: [
                .coenttbServer,
                .coenttbBlog,
                .coenttb,
                .dependenciesTestSupport
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self {
        self + " Tests"
    }
}
