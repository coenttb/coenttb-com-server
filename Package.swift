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
    static let serverRouter: Self = "Server Router"
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
    static var serverRouter: Self { .target(name: .serverRouter) }
    static var serverTranslations: Self { .target(name: .serverTranslations) }
    static var vaporApp: Self { .target(name: .vaporApp) }
}

extension Target.Dependency {
    static var coenttbWeb: Self { .product(name: "CoenttbWeb", package: "coenttb-web") }
    static var coenttbBlog: Self { .product(name: "CoenttbBlog", package: "coenttb-blog") }
    static var coenttbIdentity: Self { .product(name: "CoenttbIdentity", package: "coenttb-identity") }
    static var coenttbIdentityFluent: Self { .product(name: "CoenttbIdentityFluent", package: "coenttb-identity") }
    static var coenttbNewsletter: Self { .product(name: "CoenttbNewsletter", package: "coenttb-newsletter") }
    static var coenttbNewsletterFluent: Self { .product(name: "CoenttbNewsletterFluent", package: "coenttb-newsletter") }
    static var coenttbSyndication: Self { .product(name: "CoenttbSyndication", package: "coenttb-syndication") }
    
    static var googleAnalytics: Self { .product(name: "GoogleAnalytics", package: "coenttb-google-analytics") }
    static var hotjar: Self { .product(name: "Hotjar", package: "coenttb-hotjar") }
    static var mailgun: Self { .product(name: "Mailgun", package: "coenttb-mailgun") }
    static var postgres: Self { .product(name: "Postgres", package: "coenttb-postgres") }
    static var stripe: Self { .product(name: "CoenttbStripe", package: "coenttb-stripe") }
    static var stripeLive: Self { .product(name: "CoenttbStripeLive", package: "coenttb-stripe") }

    static var queuesFluentDriver: Self { .product(name: "QueuesFluentDriver", package: "vapor-queues-fluent-driver") }
    static var dependenciesMacros: Self { .product(name: "DependenciesMacros", package: "swift-dependencies") }
    static var dependenciesTestSupport: Self { .product(name: "DependenciesTestSupport", package: "swift-dependencies") }
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
        .library(name: .serverRouter, targets: [.serverRouter]),
        .library(name: .serverTranslations, targets: [.serverTranslations]),
        .library(name: .coenttb, targets: [.coenttb]),
        .library(name: .vaporApp, targets: [.vaporApp]),
        .library(name: .serverClient, targets: [.serverClient]),
        .library(name: .serverClientLive, targets: [.serverClientLive]),
        .library(name: .serverDatabase, targets: [.serverDatabase]),
        .executable(name: .server, targets: [.server])
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/coenttb-web.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-blog.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-google-analytics.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-identity.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-newsletter.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-postgres.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-hotjar.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-mailgun.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-stripe.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-syndication.git", branch: "main"),
        .package(url: "https://github.com/m-barthelemy/vapor-queues-fluent-driver.git", from: "3.0.0-beta1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.6.0"),
        
        // TIP: Ensure that any non-public dependency of a dependency requiring authentication is explicitly listed here to enable successful linking on Heroku.
    ],
    targets: [
        .target(
            name: .coenttb,
            dependencies: [
                .serverEnvVars,
                .serverTranslations,
                .serverRouter,
                .serverClientLive,
                .coenttbWeb,
                .coenttbIdentity,
                .coenttbIdentityFluent,
                .googleAnalytics,
                .hotjar,
                .mailgun,
                .stripeLive,
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
                .serverRouter,
                .dependenciesMacros,
                .coenttbWeb,
                .coenttbIdentity,
                .mailgun,
                .coenttbNewsletter,
            ]
        ),
        .target(
            name: .serverClientLive,
            dependencies: [
                .serverClient,
                .serverDependencies,
                .serverDatabase,
                .serverEnvVars,
                .serverRouter,
                .dependenciesMacros,
                .queuesFluentDriver,
                .coenttbWeb,
                .coenttbIdentity,
                .coenttbIdentityFluent,
                .coenttbNewsletter,
                .coenttbNewsletterFluent,
                .mailgun,
            ]
        ),
        .target(
            name: .serverDatabase,
            dependencies: [
                .serverDependencies,
                .serverEnvVars,
                .dependenciesMacros,
                .coenttbWeb,
                .stripe,
                .coenttbIdentityFluent,
                .coenttbNewsletterFluent,
            ]
        ),
        .target(
            name: .serverDependencies,
            dependencies: [
                .coenttbWeb,
                .serverModels,
            ]
        ),
        .target(
            name: .serverEnvVars,
            dependencies: [
                .coenttbWeb,
                .hotjar,
                .mailgun,
                .googleAnalytics,
                .postgres,
                .stripe,
            ]
        ),
        .target(
            name: .serverModels,
            dependencies: [
                .serverEnvVars,
                .coenttbWeb,
                .coenttbIdentity,
                .stripe,
            ]
        ),
        .target(
            name: .serverRouter,
            dependencies: [
                .serverDependencies,
                .serverTranslations,
                .coenttbWeb,
                .coenttbBlog,
                .coenttbIdentity,
                .coenttbSyndication,
                .stripe,
                .coenttbNewsletter,
            ]
        ),
        .target(
            name: .serverTranslations,
            dependencies: [
                .coenttbWeb,
            ]
        ),
        .target(
            name: .vaporApp,
            dependencies: [
                .serverEnvVars,
                .serverClient,
                .serverDependencies,
                .coenttbWeb,
                .coenttb,
                .coenttbNewsletter,
                .coenttbBlog,
                .queuesFluentDriver,
            ]
//            swiftSettings: [
//                .unsafeFlags(
//                    {
//                        #if os(Linux)
//                        return ["-I/usr/include", "-L/usr/lib"]
//                        #else
//                        return ["-I/opt/homebrew/include", "-L/opt/homebrew/lib"]
//                        #endif
//                    }()
//                )
//            ],
//            linkerSettings: [
//                .linkedLibrary("gd")
//            ]
        ),
        .executableTarget(
            name: .server,
            dependencies: [
                .vaporApp,
                .coenttbWeb,
            ]
        ),
        .testTarget(
            name: .coenttb.tests,
            dependencies: [
                .coenttbWeb,
                .coenttbBlog,
                .coenttb,
                .dependenciesTestSupport,
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
