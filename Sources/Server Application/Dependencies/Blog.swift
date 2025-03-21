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

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension BlogKey: @retroactive DependencyKey {
    public static let liveValue: Coenttb_Blog.Client = .init(
        getAll: {
            @Dependency(\.envVars.appEnv) var appEnv
            @Dependency(\.date.now) var now
            
            return [Coenttb_Blog.Blog.Post].allCases
                .filter {
                    appEnv == .production
                    ? $0.publishedAt <= now
                    : true
                }
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
        }
    )
}
