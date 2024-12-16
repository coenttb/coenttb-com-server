// swift-tools-version:6.0.0

import Foundation
import PackageDescription

extension String {
    static let envVars: Self = "EnvVars"
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
    static var envVars: Self { .target(name: .envVars) }
    static var serverDatabase: Self { .target(name: .serverDatabase) }
    static var serverDependencies: Self { .target(name: .serverDependencies) }
    static var serverModels: Self { .target(name: .serverModels) }
    static var serverRouter: Self { .target(name: .serverRouter) }
    static var serverTranslations: Self { .target(name: .serverTranslations) }
    static var coenttb: Self { .target(name: .coenttb) }
    static var vaporApp: Self { .target(name: .vaporApp) }
}

extension Target.Dependency {
    static var coenttbWebStripe: Self { .product(name: "CoenttbWebStripe", package: "coenttb-web") }
    static var coenttbWebStripeLive: Self { .product(name: "CoenttbWebStripeLive", package: "coenttb-web") }
    static var coenttbWebAccount: Self { .product(name: "CoenttbWebAccount", package: "coenttb-web") }
    static var coenttbWebAccountLive: Self { .product(name: "CoenttbWebAccountLive", package: "coenttb-web") }
    static var appSecret: Self { .product(name: "AppSecret", package: "swift-web") }
    static var databaseHelpers: Self { .product(name: "DatabaseHelpers", package: "swift-web") }
    static var casepaths: Self { .product(name: "CasePaths", package: "swift-case-paths") }
    static var coenttbEmail: Self { .product(name: "CoenttbEmail", package: "coenttb-html") }
    static var coenttbEnvVars: Self { .product(name: "CoenttbEnvVars", package: "coenttb-web") }
    static var coenttbWebHTML: Self { .product(name: "CoenttbWebHTML", package: "coenttb-web") }
    static var coenttbWebDatabase: Self { .product(name: "CoenttbWebDatabase", package: "coenttb-web") }
    static var coenttbWebDependencies: Self { .product(name: "CoenttbWebDependencies", package: "coenttb-web") }
    static var coenttbWebUtils: Self { .product(name: "CoenttbWebUtils", package: "coenttb-web") }
    static var coenttbWebModels: Self { .product(name: "CoenttbWebModels", package: "coenttb-web") }
    static var coenttbWebLegal: Self { .product(name: "CoenttbWebLegal", package: "coenttb-web") }
    static var coenttbWebNewsletter: Self { .product(name: "CoenttbWebNewsletter", package: "coenttb-web") }
    static var coenttbWebBlog: Self { .product(name: "CoenttbWebBlog", package: "coenttb-web") }
    static var coenttbWebTranslations: Self { .product(name: "CoenttbWebTranslations", package: "coenttb-web") }
    static var coenttbServerRouter: Self { .product(name: "CoenttbServerRouter", package: "coenttb-web") }
    static var coenttbVapor: Self { .product(name: "CoenttbVapor", package: "coenttb-web") }
    static var decodableRequest: Self { .product(name: "DecodableRequest", package: "swift-web") }
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var dependenciesMacros: Self { .product(name: "DependenciesMacros", package: "swift-dependencies") }
    static var either: Self { .product(name: "Either", package: "swift-prelude") }
    static var emailaddress: Self { .product(name: "EmailAddress", package: "swift-web") }
    static var favicon: Self { .product(name: "Favicon", package: "swift-web") }
    static var fluent: Self { .product(name: "Fluent", package: "fluent") }
    static var fluentPostgresDriver: Self { .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver") }
    static var foundationPrelude: Self { .product(name: "FoundationPrelude", package: "swift-web") }
    static var gitHub: Self { .product(name: "GitHub", package: "coenttb-web") }
    static var hotjar: Self { .product(name: "Hotjar", package: "coenttb-web") }
    static var postgres: Self { .product(name: "Postgres", package: "coenttb-web") }
    static var googleAnalytics: Self { .product(name: "GoogleAnalytics", package: "coenttb-web") }
    static var httpPipeline: Self { .product(name: "HttpPipeline", package: "swift-web") }
    static var language: Self { .product(name: "Languages", package: "swift-language") }
    static var logging: Self { .product(name: "Logging", package: "swift-log") }
    static var loggingDependencies: Self { .product(name: "LoggingDependencies", package: "swift-web") }
    static var macroCodableKit: Self { .product(name: "MacroCodableKit", package: "macro-codable-kit") }
    static var mailgun: Self { .product(name: "Mailgun", package: "coenttb-web") }
    static var mediaType: Self { .product(name: "MediaType", package: "swift-web") }
    static var memberwiseInit: Self { .product(name: "MemberwiseInit", package: "swift-memberwise-init-macro") }
    static var money: Self { .product(name: "Money", package: "swift-money") }
    static var nioDependencies: Self { .product(name: "NIODependencies", package: "swift-web") }
    static var percent: Self { .product(name: "Percent", package: "swift-percent") }
    static var postgresKit: Self { .product(name: "PostgresKit", package: "postgres-kit") }
    static var queuesFluentDriver: Self { .product(name: "QueuesFluentDriver", package: "vapor-queues-fluent-driver") }
    static var sitemap: Self { .product(name: "Sitemap", package: "swift-web") }
    static var splash: Self { .product(name: "Splash", package: "Splash") }
    static var stripeKit: Self { .product(name: "StripeKit", package: "stripe-kit") }
    static var swiftDate: Self { .product(name: "Date", package: "swift-date") }
    static var tagged: Self { .product(name: "Tagged", package: "swift-tagged") }
    static var taggedMoney: Self { .product(name: "TaggedMoney", package: "swift-tagged") }
    static var urlFormCoding: Self { .product(name: "UrlFormCoding", package: "swift-web") }
    static var urlFormEncoding: Self { .product(name: "UrlFormEncoding", package: "swift-web") }
    static var urlRouting: Self { .product(name: "URLRouting", package: "swift-url-routing") }
    static var vapor: Self { .product(name: "Vapor", package: "vapor") }
    static var vaporRouting: Self { .product(name: "VaporRouting", package: "vapor-routing") }
}

let package = Package(
    name: "coenttb-com-server",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: .envVars, targets: [.envVars]),
        .library(name: .serverDatabase, targets: [.serverDatabase]),
        .library(name: .serverDependencies, targets: [.serverDependencies]),
        .library(name: .serverModels, targets: [.serverModels]),
        .library(name: .serverRouter, targets: [.serverRouter]),
        .library(name: .serverTranslations, targets: [.serverTranslations]),
        .library(name: .coenttb, targets: [.coenttb]),
        .library(name: .vaporApp, targets: [.vaporApp])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.1"),
        .package(url: "https://github.com/coenttb/coenttb-web.git", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-html.git", branch: "main"),
        .package(url: "https://github.com/coenttb/macro-codable-kit.git", branch: "main"),
        .package(url: "https://github.com/gohanlon/swift-memberwise-init-macro", from: "0.3.0"),
        .package(url: "https://github.com/m-barthelemy/vapor-queues-fluent-driver.git", from: "3.0.0-beta1"),
        .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "1.1.3"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.1.5"),
        .package(url: "https://github.com/pointfreeco/swift-navigation", from: "2.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-prelude.git", branch: "main"),
        .package(url: "https://github.com/pointfreeco/swift-tagged.git", from: "0.10.0"),
        .package(url: "https://github.com/pointfreeco/swift-url-routing", from: "0.6.0"),
        .package(url: "https://github.com/pointfreeco/vapor-routing.git", from: "0.1.3"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.10.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.2"),
        .package(url: "https://github.com/vapor/postgres-kit", from: "2.12.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.105.2"),
        .package(url: "https://github.com/vapor-community/stripe-kit.git", from: "25.1.1"),

        // Any dependency of a dependency that requires authentication should be directly included here for linking on heroku to succeed.
        .package(url: "https://github.com/coenttb/swift-css.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-date.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-html.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-language.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-money.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-percent.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-web.git", branch: "main")
    ],
    targets: [
        .target(
            name: .envVars,
            dependencies: [
                .appSecret,
                .coenttbWebModels,
                .dependencies,
                .gitHub,
                .language,
                .logging,
                .mailgun,
                .memberwiseInit,
                .serverModels,
                .tagged,
                .coenttbEnvVars,
                .hotjar,
                .googleAnalytics,
                .postgres,
            ]
        ),
        .target(
            name: .serverDatabase,
            dependencies: [
                .dependenciesMacros,
                .coenttbWebModels,
                .coenttbWebDatabase,
                .coenttbServerRouter,
                .dependencies,
                .emailaddress,
                .envVars,
                .fluent,
                .language,
                .mailgun,
                .serverDependencies,
                .serverRouter,
                .tagged,
                .vapor,
                .coenttbEmail,
                .coenttbWebAccount,
                .coenttbWebUtils,
                .queuesFluentDriver
            ]
        ),
        .target(
            name: .serverDependencies,
            dependencies: [
                .serverModels,
                .coenttbWebDependencies,
                .postgresKit
            ]
        ),
        .target(
            name: .serverModels,
            dependencies: [
                .emailaddress,
                .coenttbWebModels,
                .coenttbWebStripe,
                .coenttbWebAccount
            ]
        ),
        .target(
            name: .serverRouter,
            dependencies: [
                .macroCodableKit,
                .memberwiseInit,
                .favicon,
                .serverTranslations,
                .serverDependencies,
                .urlFormCoding,
                .urlRouting,
                .coenttbWebModels,
                .coenttbServerRouter,
                .coenttbWebStripe,
                .coenttbWebNewsletter,
                .coenttbWebAccount,
                .coenttbWebBlog
            ]
        ),
        .target(
            name: .serverTranslations,
            dependencies: [
                .coenttbWebHTML,
                .coenttbWebTranslations
            ]
        ),
        .target(
            name: .coenttb,
            dependencies: [
                .serverTranslations,
                .coenttbWebHTML,
                .coenttbWebModels,
                .envVars,
                .gitHub,
                .loggingDependencies,
                .mailgun,
                .serverDatabase,
                .serverModels,
                .serverRouter,
                .sitemap,
                .coenttbWebAccount,
                .swiftDate,
                .vapor,
                .coenttbWebStripeLive,
                .coenttbWebLegal,
                .hotjar,
                .googleAnalytics,
            ],
            resources: [
                .process("Blog/Posts")
            ]
        ),
        .target(
            name: .vaporApp,
            dependencies: [
                .coenttbVapor,
                .fluent,
                .fluentPostgresDriver,
                .coenttbWebHTML,
                .loggingDependencies,
                .nioDependencies,
                .serverDependencies,
                .sitemap,
                .swiftDate,
                .coenttb,
                .vapor,
                .vaporRouting,
                .serverDatabase,
                .coenttbWebNewsletter,
                .queuesFluentDriver,
                .coenttbWebStripeLive,
                .coenttbWebAccountLive
            ]
        ),
        .executableTarget(
            name: .server,
            dependencies: [
                .vaporApp,
                .coenttbVapor
            ]
        ),
        .testTarget(
            name: "Coenttb Tests",
            dependencies: [.coenttbWebHTML, .coenttb])
    ],
    swiftLanguageModes: [.v6]
)
