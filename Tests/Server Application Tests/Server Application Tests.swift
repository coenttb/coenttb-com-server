//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 23/12/2024.
//

import Foundation
import Testing
import Coenttb_Server
import DependenciesTestSupport
import Coenttb_Blog
@testable import Server_Application

//@Suite("Blog Post Tests")
//struct BlogPostTests {
//    @Test("All cases should have valid index values")
//    func testBlogPostIndices() {
//        let posts = [Blog.Post].allCases
//        for post in posts {
//            #expect(post.index >= 0, "Post index should be non-negative")
//            #expect(post.id.uuidString.isEmpty == false, "Post ID should be valid")
//        }
//    }
//}

@Suite(
    "Emails Tests",
    .dependency(\.color, .coenttb),
    .dependency(\.date, .init(Date.init)),
    .dependency(\.calendar, .autoupdatingCurrent),
    .dependency(\.coenttb, .liveValue)
)
struct EmailsTests {
    @Test("Generate newsletter 1 html")
    func newsletter1() throws  {
        let html: some HTML = Email.newsletter1()
        let bytes: ContiguousArray<UInt8> = html.render()
        let string: String = String(decoding: bytes, as: UTF8.self)
        
        try string.write(toFile: URL.documentsDirectory.appending(path: "newsletter1.html"))
    }
}
