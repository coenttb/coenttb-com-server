//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 19/08/2024.
//

import CoenttbMarkdown
import CoenttbWebBlog
import CoenttbWebHTML
import Date
import Dependencies
import Foundation
import Languages
import ServerRouter

extension DependencyValues {
    public var previewPosts: @Sendable () -> [Blog.Post] {
        get { self[PreviewPostKey.self] }
        set { self[PreviewPostKey.self] = newValue }
    }
}

public enum PreviewPostKey: TestDependencyKey {
    nonisolated(unsafe)
    public static var testValue: @Sendable () -> [Blog.Post] = {
        [
            .init(
                id: .init(),
                index: -1,
                publishedAt: .init(timeIntervalSince1970: 1_523_872_623),
                image: Image.coenttbGreenSuit.halftone(),
                title: "Mock Blog post",
                hidden: .no,
                blurb: """
                This is the blurb to a mock blog post. This should just be short and to the point, using \
                only plain text, no markdown.
                """,
                estimatedTimeToComplete: 10.minutes,
                permission: .free
            )
        ]
    }
}
