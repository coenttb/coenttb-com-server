// swift-tools-version:6.0

import Foundation
import PackageDescription

extension String {
    static let server: Self = "Server"
    static let serverClient: Self = "Server Client"
    static let serverDatabase: Self = "Server Database"
    static let serverDependencies: Self = "Server Dependencies"
    static let serverEnvVars: Self = "Server EnvVars"
    static let serverModels: Self = "Server Models"
    static let serverIntegration: Self = "Server Integration"
    static let serverTranslations: Self = "Server Translations"
    static let vaporApplication: Self = "Vapor Application"
}

extension Target.Dependency {
    static var serverClient: Self { .target(name: .serverClient) }
    static var serverDatabase: Self { .target(name: .serverDatabase) }
    static var serverEnvVars: Self { .target(name: .serverEnvVars) }
    static var serverDependencies: Self { .target(name: .serverDependencies) }
    static var serverModels: Self { .target(name: .serverModels) }
    static var serverIntegration: Self { .target(name: .serverIntegration) }
    static var serverTranslations: Self { .target(name: .serverTranslations) }
    static var vaporApplication: Self { .target(name: .vaporApplication) }
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
        .executable(name: .server, targets: [.server]),
        .library(name: .serverClient, targets: [.serverClient]),
        .library(name: .serverDatabase, targets: [.serverDatabase]),
        .library(name: .serverDependencies, targets: [.serverDependencies]),
        .library(name: .serverEnvVars, targets: [.serverEnvVars]),
        .library(name: .serverModels, targets: [.serverModels]),
        .library(name: .serverTranslations, targets: [.serverTranslations]),
        .library(name: .serverIntegration, targets: [.serverIntegration]),
        .library(name: .vaporApplication, targets: [.vaporApplication]),
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
        .package(url: "https://github.com/coenttb/coenttb-syndication.git", branch: "main"),
        .package(url: "https://github.com/m-barthelemy/vapor-queues-fluent-driver.git", from: "3.0.0-beta1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.9.2"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.110.2"),
        .package(url: "https://github.com/apple/swift-crypto.git", exact: "3.12.3"),
    ],
    targets: [
        .executableTarget(
            name: .server,
            dependencies: [
                .vaporApplication,
                .coenttbServer
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
                .serverDatabase
            ]
        ),
        .testTarget(
            name: .serverClient.tests,
            dependencies: [
                .serverClient,
                .dependenciesTestSupport
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
                .dependenciesMacros
//                .stripe,
            ]
        ),
        .testTarget(
            name: .serverDatabase.tests,
            dependencies: [
                .serverDatabase,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .serverDependencies,
            dependencies: [
                .coenttbServer,
                .serverModels,
                .coenttbComShared
            ]
        ),
        .testTarget(
            name: .serverDependencies.tests,
            dependencies: [
                .serverDependencies,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .serverEnvVars,
            dependencies: [
                .coenttbServer,
                .hotjar,
                .mailgun,
                .googleAnalytics,
                .postgres
//                .stripe,
            ]
        ),
        .testTarget(
            name: .serverEnvVars.tests,
            dependencies: [
                .serverEnvVars,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .serverModels,
            dependencies: [
                .serverEnvVars,
                .coenttbServer
            ]
        ),
        .testTarget(
            name: .serverModels.tests,
            dependencies: [
                .serverModels,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .serverIntegration,
            dependencies: [
                .serverEnvVars,
                .serverTranslations,
                .serverClient,
                .coenttbIdentityConsumer,
                .googleAnalytics,
                .hotjar,
                .mailgun,
                .coenttbLegalDocuments,
                .coenttbServer,
                .coenttbComShared
            ],
            resources: [
                .process("Blog/Posts")
            ]
        ),
        .testTarget(
            name: .serverIntegration.tests,
            dependencies: [
                .serverIntegration,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .serverTranslations,
            dependencies: [
                .coenttbServer
            ]
        ),
        .target(
            name: .vaporApplication,
            dependencies: [
                .coenttbServer,
                .coenttbServerVapor,
                .serverEnvVars,
                .serverClient,
                .serverDependencies,
                .serverIntegration,
                .coenttbNewsletter,
                .queuesFluentDriver,
                .coenttbSyndicationVapor,
                .coenttbBlogVapor,
                .coenttbComShared
            ]
        ),
        .testTarget(
            name: .vaporApplication.tests,
            dependencies: [
                .vaporApplication,
                .vaporTesting,
                .dependenciesTestSupport
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self {
        self + " Tests"
    }
}
