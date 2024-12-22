// swift-tools-version:6.0.0

import Foundation
import PackageDescription

extension String {
    static let serverEnvVars: Self = "ServerEnvVars"
    static let serverDatabase: Self = "ServerDatabase"
    static let serverDependencies: Self = "ServerDependencies"
    static let serverModels: Self = "ServerModels"
    static let serverRouter: Self = "ServerRouter"
    static let serverTranslations: Self = "ServerTranslations"
    static let coenttb: Self = "Coenttb"
    static let vaporApp: Self = "VaporApp"
    static let server: Self = "Server"
}

extension Target.Dependency {
    static var serverEnvVars: Self { .target(name: .serverEnvVars) }
    static var serverDatabase: Self { .target(name: .serverDatabase) }
    static var serverDependencies: Self { .target(name: .serverDependencies) }
    static var serverModels: Self { .target(name: .serverModels) }
    static var serverRouter: Self { .target(name: .serverRouter) }
    static var serverTranslations: Self { .target(name: .serverTranslations) }
    static var coenttb: Self { .target(name: .coenttb) }
    static var vaporApp: Self { .target(name: .vaporApp) }
}

extension Target.Dependency {
    static var coenttbIdentity: Self { .product(name: "CoenttbIdentity", package: "coenttb-identity") }
    static var coenttbIdentityFluent: Self { .product(name: "CoenttbIdentityFluent", package: "coenttb-identity") }
    static var coenttbSyndication: Self { .product(name: "CoenttbSyndication", package: "coenttb-syndication") }
    static var blog: Self { .product(name: "CoenttbBlog", package: "coenttb-blog") }
    static var newsletter: Self { .product(name: "CoenttbNewsletter", package: "coenttb-newsletter") }
    static var newsletterFluent: Self { .product(name: "CoenttbNewsletterFluent", package: "coenttb-newsletter") }
    static var hotjar: Self { .product(name: "Hotjar", package: "coenttb-hotjar") }
    static var mailgun: Self { .product(name: "Mailgun", package: "coenttb-mailgun") }
    static var googleAnalytics: Self { .product(name: "GoogleAnalytics", package: "coenttb-google-analytics") }
    static var stripe: Self { .product(name: "CoenttbStripe", package: "coenttb-stripe") }
    static var stripeLive: Self { .product(name: "CoenttbStripeLive", package: "coenttb-stripe") }
    static var postgres: Self { .product(name: "Postgres", package: "coenttb-postgres") }
    static var coenttbWeb: Self { .product(name: "CoenttbWeb", package: "coenttb-web") }
    static var queuesFluentDriver: Self { .product(name: "QueuesFluentDriver", package: "vapor-queues-fluent-driver") }
    static var dependenciesMacros: Self { .product(name: "DependenciesMacros", package: "swift-dependencies") }
}

let package = Package(
    name: "coenttb-com-server",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: .serverEnvVars, targets: [.serverEnvVars]),
        .library(name: .serverDatabase, targets: [.serverDatabase]),
        .library(name: .serverDependencies, targets: [.serverDependencies]),
        .library(name: .serverModels, targets: [.serverModels]),
        .library(name: .serverRouter, targets: [.serverRouter]),
        .library(name: .serverTranslations, targets: [.serverTranslations]),
        .library(name: .coenttb, targets: [.coenttb]),
        .library(name: .vaporApp, targets: [.vaporApp])
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/coenttb-web.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-blog.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-newsletter.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-identity.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-postgres.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-google-analytics.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-hotjar.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-syndication.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-mailgun.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-stripe.git", branch: "main"),
        .package(url: "https://github.com/m-barthelemy/vapor-queues-fluent-driver.git", from: "3.0.0-beta1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.6.0"),
        
        // Any dependency of a dependency that requires authentication should be directly included here for linking on heroku to succeed.
    ],
    targets: [
        .target(
            name: .serverEnvVars,
            dependencies: [
                .coenttbWeb,
                .hotjar,
                .mailgun,
                .googleAnalytics,
                .postgres,
                .stripe,
                .stripeLive,
            ]
        ),
        .target(
            name: .serverDatabase,
            dependencies: [
                .coenttbWeb,
                .coenttbIdentity,
                .coenttbIdentityFluent,
                .serverEnvVars,
                .mailgun,
                .serverDependencies,
                .serverRouter,
                .queuesFluentDriver,
                .dependenciesMacros,
                .newsletterFluent,
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
            name: .serverModels,
            dependencies: [
                .coenttbWeb,
                .stripe,
                .coenttbIdentity,
                .serverEnvVars,
            ]
        ),
        .target(
            name: .serverRouter,
            dependencies: [
                .blog,
                .coenttbWeb,
                .coenttbIdentity,
                .coenttbSyndication,
                .serverTranslations,
                .serverDependencies,
                .stripe,
                .newsletter,
            ]
        ),
        .target(
            name: .serverTranslations,
            dependencies: [
                .coenttbWeb,
            ]
        ),
        .target(
            name: .coenttb,
            dependencies: [
                .coenttbIdentity,
                .coenttbWeb,
                .serverEnvVars,
                .googleAnalytics,
                .hotjar,
                .mailgun,
                .serverTranslations,
                .serverDatabase,
                .serverModels,
                .serverRouter,
                .stripeLive,
            ],
            resources: [
                .process("Blog/Posts")
            ]
        ),
        .target(
            name: .vaporApp,
            dependencies: [
                .coenttbWeb,
                .serverEnvVars,
                .serverDependencies,
                .coenttb,
                .serverDatabase,
                .newsletter,
                .queuesFluentDriver,
                .stripeLive,
                .coenttbIdentityFluent,
                .blog,
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
            name: "Coenttb Tests",
            dependencies: [.coenttbWeb, .coenttb])
    ],
    swiftLanguageModes: [.v6]
)
