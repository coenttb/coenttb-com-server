// swift-tools-version:6.2

import Foundation
import PackageDescription

// MARK: - String Extensions for Target Names
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
    static let coenttbRouter: Self = "CoenttbRouter"
    static let coenttbShared: Self = "CoenttbShared"
    static let coenttbUI: Self = "CoenttbUI"
}

// MARK: - Target Dependency Extensions
extension Target.Dependency {
    // Internal targets
    static var serverClient: Self { .target(name: .serverClient) }
    static var serverDatabase: Self { .target(name: .serverDatabase) }
    static var serverEnvVars: Self { .target(name: .serverEnvVars) }
    static var serverDependencies: Self { .target(name: .serverDependencies) }
    static var serverModels: Self { .target(name: .serverModels) }
    static var serverIntegration: Self { .target(name: .serverIntegration) }
    static var serverTranslations: Self { .target(name: .serverTranslations) }
    static var vaporApplication: Self { .target(name: .vaporApplication) }
    static var coenttbRouter: Self { .target(name: .coenttbRouter) }
    static var coenttbShared: Self { .target(name: .coenttbShared) }
    static var coenttbUI: Self { .target(name: .coenttbUI) }

    // External dependencies - Boiler & Server Foundation
    static var boiler: Self { .product(name: "Boiler", package: "boiler") }
    static var serverFoundation: Self { .product(name: "ServerFoundation", package: "swift-server-foundation") }
    static var serverFoundationVapor: Self { .product(name: "ServerFoundationVapor", package: "swift-server-foundation-vapor") }

    // Blog & Newsletter
    static var coenttbBlog: Self { .product(name: "Coenttb Blog", package: "coenttb-blog") }
    static var coenttbBlogVapor: Self { .product(name: "Coenttb Blog Vapor", package: "coenttb-blog") }
    static var coenttbNewsletter: Self { .product(name: "Coenttb Newsletter", package: "coenttb-newsletter") }
    static var coenttbNewsletterLive: Self { .product(name: "Coenttb Newsletter Live", package: "coenttb-newsletter") }
    static var coenttbNewsletterRecords: Self { .product(name: "Coenttb Newsletter Records", package: "coenttb-newsletter") }

    // Syndication
    static var coenttbSyndication: Self { .product(name: "Coenttb Syndication", package: "coenttb-syndication") }
    static var coenttbSyndicationVapor: Self { .product(name: "Coenttb Syndication Vapor", package: "coenttb-syndication") }

    // Legal
    static var coenttbLegalDocuments: Self { .product(name: "Coenttb Legal Documents", package: "coenttb") }

    // HTML & UI
    static var html: Self { .product(name: "HTML", package: "swift-html") }
    static var htmlMarkdown: Self { .product(name: "HTMLMarkdown", package: "swift-html") }
    static var htmlTheme: Self { .product(name: "HTMLTheme", package: "swift-html") }
    static var htmlWebsite: Self { .product(name: "HTMLWebsite", package: "swift-html") }
    static var favicon: Self { .product(name: "Favicon", package: "swift-favicon") }
    static var svg: Self { .product(name: "SVG", package: "swift-svg") }

    // Analytics & Tracking
    static var googleAnalytics: Self { .product(name: "GoogleAnalytics", package: "coenttb-google-analytics") }
    static var hotjar: Self { .product(name: "Hotjar", package: "coenttb-hotjar") }

    // Infrastructure
    static var mailgun: Self { .product(name: "Mailgun", package: "swift-mailgun") }
    static var postgres: Self { .product(name: "Postgres", package: "coenttb-postgres") }
    static var queuesFluentDriver: Self { .product(name: "QueuesFluentDriver", package: "vapor-queues-fluent-driver") }

    // Point-Free Dependencies
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var dependenciesMacros: Self { .product(name: "DependenciesMacros", package: "swift-dependencies") }
    static var dependenciesTestSupport: Self { .product(name: "DependenciesTestSupport", package: "swift-dependencies") }
    static var issueReporting: Self { .product(name: "IssueReporting", package: "xctest-dynamic-overlay") }

    // Testing
    static var vaporTesting: Self { .product(name: "VaporTesting", package: "vapor") }

    // Localization
    static var translating: Self { .product(name: "Translating", package: "swift-translating") }
}

// MARK: - Test Target Name Extension
extension String {
    var tests: Self { "\(self) Tests" }
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
        .library(name: .coenttbRouter, targets: [.coenttbRouter]),
        .library(name: .coenttbShared, targets: [.coenttbShared]),
        .library(name: .coenttbUI, targets: [.coenttbUI])
    ],
    dependencies: [
        // Core Framework
        .package(url: "https://github.com/coenttb/boiler", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-server-foundation", from: "0.5.1"),
        .package(url: "https://github.com/coenttb/swift-server-foundation-vapor", from: "0.4.1"),

        // Content Management
        .package(url: "https://github.com/coenttb/coenttb-blog", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-newsletter", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-syndication", branch: "main"),

        // UI & HTML
        .package(url: "https://github.com/coenttb/swift-html", from: "0.9.0"),
        .package(url: "https://github.com/coenttb/swift-favicon", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-svg", branch: "main"),

        // Analytics & Tracking
        .package(url: "https://github.com/coenttb/coenttb-google-analytics", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-hotjar", branch: "main"),

        // Infrastructure
        .package(url: "https://github.com/coenttb/swift-mailgun", from: "0.1.0"),
        .package(url: "https://github.com/coenttb/coenttb-postgres", branch: "main"),
        .package(url: "https://github.com/m-barthelemy/vapor-queues-fluent-driver", from: "3.0.0-beta1"),

        // Legal
        .package(url: "https://github.com/coenttb/coenttb", branch: "main"),

        // Foundation Dependencies
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.2"),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.4.3"),
        .package(url: "https://github.com/coenttb/swift-translating", from: "0.3.0"),
        .package(url: "https://github.com/vapor/vapor", from: "4.110.2")
    ],
    targets: [
        .executableTarget(
            name: .server,
            dependencies: [
                .vaporApplication,
                .serverFoundation,
                .boiler
            ]
        ),
        .target(
            name: .serverClient,
            dependencies: [
                .serverEnvVars,
                .serverDependencies,
                .dependenciesMacros,
                .serverFoundation,
                .mailgun,
                .coenttbNewsletter,
                .coenttbRouter,
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
                .serverFoundation,
                .boiler,
                .coenttbNewsletterRecords,
                .serverDependencies,
                .serverEnvVars,
                .dependenciesMacros
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
                .serverFoundation,
                .serverModels,
                .coenttbRouter
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
                .serverFoundation,
                .hotjar,
                .mailgun,
                .googleAnalytics,
                .postgres
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
                .serverFoundation
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
                .googleAnalytics,
                .hotjar,
                .mailgun,
                .coenttbLegalDocuments,
                .serverFoundation,
                .coenttbRouter
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
                .serverFoundation
            ]
        ),
        .target(
            name: .vaporApplication,
            dependencies: [
                .serverFoundation,
                .serverFoundationVapor,
                .boiler,
                .serverEnvVars,
                .serverClient,
                .serverDependencies,
                .serverIntegration,
                .coenttbNewsletter,
                .queuesFluentDriver,
                .coenttbSyndicationVapor,
                .coenttbBlogVapor,
                .coenttbRouter
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
        .target(
            name: .coenttbRouter,
            dependencies: [
                .serverFoundation,
                .issueReporting,
                .coenttbSyndication,
                .coenttbBlog,
                .coenttbNewsletter,
                .translating,
                .html
            ]
        ),
        .target(
            name: .coenttbShared,
            dependencies: [
                .serverFoundation,
                .issueReporting,
                .coenttbRouter
            ]
        ),
        .target(
            name: .coenttbUI,
            dependencies: [
                .coenttbShared,
                .coenttbRouter,
                .serverFoundation,
                .html,
                .htmlMarkdown,
                .htmlTheme,
                .favicon,
                .svg,
                .translating,
                .googleAnalytics,
                .hotjar,
                .serverEnvVars
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
