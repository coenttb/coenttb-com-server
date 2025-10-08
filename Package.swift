// swift-tools-version:6.2

import Foundation
import PackageDescription

let useLocalPackages = (try? String(contentsOfFile: "\(Context.packageDirectory)/.env.development", encoding: .utf8).contains("USE_LOCAL_PACKAGES=true")) == true

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

extension Target.Dependency {
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
}

extension Target.Dependency {
    static var boiler: Self { .product(name: "Boiler", package: "boiler") }
    static var coenttbServer: Self { .product(name: "Coenttb Server", package: "coenttb-server") }
    static var coenttbBlog: Self { .product(name: "Coenttb Blog", package: "coenttb-blog") }
    static var coenttbBlogVapor: Self { .product(name: "Coenttb Blog Vapor", package: "coenttb-blog") }
    static var coenttbNewsletter: Self { .product(name: "Coenttb Newsletter", package: "coenttb-newsletter") }
    static var coenttbNewsletterFluent: Self { .product(name: "Coenttb Newsletter Fluent", package: "coenttb-newsletter") }
    static var coenttbSyndication: Self { .product(name: "Coenttb Syndication", package: "coenttb-syndication") }
    static var coenttbSyndicationVapor: Self { .product(name: "Coenttb Syndication Vapor", package: "coenttb-syndication") }
    static var coenttbLegalDocuments: Self { .product(name: "Coenttb Legal Documents", package: "coenttb") }
    static var googleAnalytics: Self { .product(name: "GoogleAnalytics", package: "coenttb-google-analytics") }
    static var hotjar: Self { .product(name: "Hotjar", package: "coenttb-hotjar") }
    static var mailgun: Self { .product(name: "Mailgun", package: "swift-mailgun") }
    static var postgres: Self { .product(name: "Postgres", package: "coenttb-postgres") }
    static var queuesFluentDriver: Self { .product(name: "QueuesFluentDriver", package: "vapor-queues-fluent-driver") }
    static var dependenciesMacros: Self { .product(name: "DependenciesMacros", package: "swift-dependencies") }
    static var dependenciesTestSupport: Self { .product(name: "DependenciesTestSupport", package: "swift-dependencies") }
    static var vaporTesting: Self { .product(name: "VaporTesting", package: "vapor") }
    static var issueReporting: Self { .product(name: "IssueReporting", package: "xctest-dynamic-overlay") }
    static var translating: Self { .product(name: "Translating", package: "swift-translating") }
    static var coenttbWeb: Self { .product(name: "Coenttb Web", package: "coenttb-web") }
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
        useLocalPackages
            ? .package(path: "../boiler")
            : .package(url: "https://github.com/coenttb/boiler", branch: "main"),
        
        useLocalPackages
            ? .package(path: "../coenttb")
            : .package(url: "https://github.com/coenttb/coenttb", branch: "main"),
        
        useLocalPackages
            ? .package(path: "../coenttb-server")
            : .package(url: "https://github.com/coenttb/coenttb-server", branch: "main"),

        useLocalPackages
            ? .package(path: "../coenttb-blog")
            : .package(url: "https://github.com/coenttb/coenttb-blog", branch: "main"),
        
        useLocalPackages
            ? .package(path: "../coenttb-html")
            : .package(url: "https://github.com/coenttb/coenttb-html", branch: "main"),
        
        useLocalPackages
            ? .package(path: "../coenttb-google-analytics")
            : .package(url: "https://github.com/coenttb/coenttb-google-analytics", branch: "main"),
        
        useLocalPackages
            ? .package(path: "../coenttb-newsletter")
            : .package(url: "https://github.com/coenttb/coenttb-newsletter", branch: "main"),
        
        useLocalPackages
            ? .package(path: "../coenttb-postgres")
            : .package(url: "https://github.com/coenttb/coenttb-postgres", branch: "main"),
        
        useLocalPackages
            ? .package(path: "../coenttb-hotjar")
            : .package(url: "https://github.com/coenttb/coenttb-hotjar", branch: "main"),
        
        useLocalPackages
            ? .package(path: "../swift-mailgun")
            : .package(url: "https://github.com/coenttb/swift-mailgun", branch: "main"),
        
        useLocalPackages
            ? .package(path: "../coenttb-syndication")
            : .package(url: "https://github.com/coenttb/coenttb-syndication", branch: "main"),
        
        useLocalPackages
            ? .package(path: "../coenttb-server-vapor")
            : .package(url: "https://github.com/coenttb/coenttb-server-vapor", branch: "main"),
        
        useLocalPackages
            ? .package(path: "../coenttb-web")
            : .package(url: "https://github.com/coenttb/coenttb-web", branch: "main"),
        
        // External dependencies (non-coenttb)
        .package(url: "https://github.com/m-barthelemy/vapor-queues-fluent-driver", from: "3.0.0-beta1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.2"),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.4.3"),
        .package(url: "https://github.com/coenttb/swift-translating", from: "0.0.1"),
        .package(url: "https://github.com/vapor/vapor", from: "4.110.2")
    ],
    targets: [
        .executableTarget(
            name: .server,
            dependencies: [
                .vaporApplication,
                .coenttbServer,
                .boiler
            ]
        ),
        .target(
            name: .serverClient,
            dependencies: [
                .serverEnvVars,
                .serverDependencies,
                .dependenciesMacros,
                .coenttbServer,
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
                .coenttbServer,
                .boiler,
                .coenttbNewsletterFluent,
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
                .coenttbServer,
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
                .coenttbServer,
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
                .googleAnalytics,
                .hotjar,
                .mailgun,
                .coenttbLegalDocuments,
                .coenttbServer,
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
                .coenttbServer
            ]
        ),
        .target(
            name: .vaporApplication,
            dependencies: [
                .coenttbServer,
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
                .coenttbServer,
                .issueReporting,
                .coenttbSyndication,
                .coenttbBlog,
                .coenttbNewsletter,
                .translating,
                .coenttbWeb
            ]
        ),
        .target(
            name: .coenttbShared,
            dependencies: [
                .coenttbServer,
                .issueReporting,
                .coenttbRouter
            ]
        ),
        .target(
            name: .coenttbUI,
            dependencies: [
                .coenttbShared,
                .coenttbRouter,
                .coenttbServer,
                .product(name: "Coenttb Web HTML", package: "coenttb-web"),
                .product(name: "CoenttbHTML", package: "coenttb-html"),
                .product(name: "CoenttbMarkdown", package: "coenttb-html"),
                .product(name: "Translating", package: "swift-translating"),
                .googleAnalytics,
                .hotjar,
                .serverEnvVars,
                .translating
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String { var tests: Self { self + " Tests" } }
