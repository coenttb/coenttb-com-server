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
        let bytes: ContiguousArray<UInt8> = html.render()
        let string: String = String(decoding: bytes, as: UTF8.self)
        
        try string.write(toFile: URL.documentsDirectory.appending(path: "newsletter1.html"))
    }
    
    @Test("Generate newsletter 2 html")
    func newsletter2() async throws  {
        let html: some HTML = Email.newsletter2()
        let bytes: ContiguousArray<UInt8> = html.render()
        let string: String = String(decoding: bytes, as: UTF8.self)
        
        try string.write(toFile: URL.documentsDirectory.appending(path: "newsletter2.html"))
    }
}


//
//let email = try Email.init(
//    from: .init("coen@coenttb.com"),
//    to: [.init("test@mg.coenttb.com")],
//    subject: "#\(3) A Tour of PointFreeHTML",
//    html: string,
//    text: nil,
//    cc: nil,
//    bcc: nil,
//    ampHtml: nil,
//    template: nil,
//    templateVersion: nil,
//    templateText: nil,
//    templateVariables: nil,
//    attachments: nil,
//    inline: nil,
//    tags: nil,
//    dkim: nil,
//    secondaryDkim: nil,
//    secondaryDkimPublic: nil,
//    deliveryTime: nil,
//    deliveryTimeOptimizePeriod: nil,
//    timeZoneLocalize: nil,
//    testMode: nil,
//    tracking: nil,
//    trackingClicks: nil,
//    trackingOpens: nil,
//    requireTls: nil,
//    skipVerification: nil,
//    sendingIp: nil,
//    sendingIpPool: nil,
//    trackingPixelLocationTop: nil,
//    headers: nil,
//    variables: nil,
//    recipientVariables: nil
//)
//
//@Dependency(\.mailgunClient?.messages.send) var send
//
//let result = try await Mailgun.Client.liveValue?.messages.send(request: email)
//
//print(result)
//
