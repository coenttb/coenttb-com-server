//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 12/03/2025.
//

import Coenttb_Blog
import Coenttb_Com_Shared
import Coenttb_Newsletter
import Coenttb_Server
import Server_Client
import Server_Dependencies
import Server_Models

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Blog: @retroactive DependencyKey {
    public static var liveValue: Blog {
        .init(
            client: .liveValue,
            configuration: .liveValue
        )
    }
}

extension Blog.Client: @retroactive DependencyKey {
    public static var liveValue: Blog.Client {
        .init(
            getAll: [Blog.Post].static,
            filenameToResourceUrl: Bundle.blog(fileName:),
            postToRoute: URL.init(post:),
            postToFilename: Blog.Post.translated,
            getCurrentUser: {
                @Dependency(\.currentUser) var currentUser
                guard
                    let newsletterSubscribed = currentUser?.newsletterSubscribed,
                    let accessToBlog = currentUser?.accessToBlog
                else { return nil }

                return (newsletterSubscribed: newsletterSubscribed, accessToBlog: accessToBlog)
            }
        )
    }
}

extension [Blog.Post] {
    nonisolated(unsafe) static let `static`: () -> Self = {
        @Dependency(\.envVars.appEnv) var appEnv
        @Dependency(\.date.now) var now

        return [Coenttb_Blog.Blog.Post].allCases
            .filter {
                switch appEnv {
                case .production,
                        .staging:
                    return $0.publishedAt <= now
                case .development,
                        .testing:
                    return true
                }
            }
            .sorted(by: { $0.publishedAt < $1.publishedAt })
    }
}

extension Bundle {
    static func blog(fileName: String) -> URL? {
        Bundle.module.url(forResource: fileName, withExtension: "md")
        ?? Bundle.module.url(forResource: fileName.replacingOccurrences(of: "-nl-", with: "-en-"), withExtension: "md")
    }
}

extension Blog.Post {
    static func filenameLiteral(post: Blog.Post) -> TranslatedString {
        .init("\(post.index) \(post.title)")
    }
    
    static func translated(post: Blog.Post) -> TranslatedString {
        return .init { language in
            [
                "\(post.index)",
                language.rawValue,
                post.category.map { $0(language) },
                post.title.replacingOccurrences(of: ":", with: "-")
            ]
                .compactMap { $0 }
                .joined(separator: "-")
        }
    }
}

extension URL {
    public init(post: Blog.Post) {
        @Dependency(\.coenttb.website.router) var serverRouter
        self = serverRouter.url(for: .blog(.post(post)))
    }
}

extension Blog.Configuration: @retroactive DependencyKey {
    public static var liveValue: Blog.Configuration {
        @Dependency(\.envVars.companyXComHandle) var companyXComHandle
        return .init(
            titleBlurb: String.oneliner,
            companyXComHandle: companyXComHandle,
            newsletterSection: {
                @Dependency(\.coenttb.website.router) var serverRouter
                @Dependency(\.currentUser) var currentUser

                return HTMLGroup {
                    if currentUser?.newsletterSubscribed != true {
                        Newsletter.Route.View.Subscribe.Overlay(
                            title: String.keep_in_touch_with_Coen.capitalizingFirstLetter().description,
                            caption: String.you_will_periodically_receive_articles_on.capitalizingFirstLetter().period.description
                        ) {
                            Circle {
                                Image.coenttbGreenSuit
                                    .objectPosition(.twoValues(.percentage(50), .percentage(50)))
                            }
                        }
                    } else {
                        HTMLEmpty()
                    }
                }
            }
        )
    }
}
