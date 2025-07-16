//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 12/03/2025.
//

import Coenttb_Server
import Coenttb_Blog
import Server_Client
import Server_Dependencies
import Server_Models
import Coenttb_Com_Shared
import Coenttb_Newsletter

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Blog: @retroactive DependencyKey {
    public static var liveValue: Blog {
        @Dependency(\.envVars.companyXComHandle) var companyXComHandle
        return .init(
            client: .liveValue,
            configuration: .init(
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
        )
    }
}

extension Blog.Client: @retroactive DependencyKey {
    public static var liveValue: Blog.Client {
        .init(
            getAll: {
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
            },
            filenameToResourceUrl: { fileName in
                Bundle.module.url(forResource: fileName, withExtension: "md")
            },
            postToRoute: { post in
                @Dependency(\.coenttb.website.router) var serverRouter
                return serverRouter.url(for: .blog(.post(post)))
            },
            postToFilename: { post in
                return .init { language in
                    [
                        post.category.map{ $0(language) },
                        "\(post.index)",
                        language.rawValue
                    ]
                        .compactMap{ $0 }
                        .joined(separator: "-")
                }
            },
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
