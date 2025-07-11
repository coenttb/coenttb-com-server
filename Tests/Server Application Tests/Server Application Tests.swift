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
import Dependencies
import Mailgun


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
        try! String(html).write(toFile: URL.documentsDirectory.appending(path: "newsletter1.html"))
    }
    
    @Test("Generate newsletter 2 html")
    func newsletter2() async throws  {
        let html: some HTML = Email.newsletter2()
        try! String(html).write(toFile: URL.documentsDirectory.appending(path: "newsletter2.html"))
    }
    
    @Test("Generate newsletter 3 html")
    func newsletter3() async throws  {
        let html: some HTML = Email.newsletter3()
        try! String(html).write(toFile: URL.documentsDirectory.appending(path: "newsletter3.html"))
    }
}
