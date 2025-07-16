//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 23/12/2024.
//

import Coenttb_Blog
import Coenttb_Server
import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun
@testable import Server_Application
import Testing

@Suite(
    "Emails Tests",
    .dependency(\.color, .coenttb),
    .dependency(\.date, .init(Date.init)),
    .dependency(\.calendar, .autoupdatingCurrent),
    .dependency(\.coenttb, .liveValue)
)
struct EmailsTests {
    @Test("Generate newsletter 1 html")
    func newsletter1() throws {
        let html: some HTML = Email.newsletter1()
        try String(html).write(toFile: URL.documentsDirectory.appending(path: "newsletter1.html"))
    }

    @Test("Generate newsletter 2 html")
    func newsletter2() async throws {
        let html: some HTML = Email.newsletter2()
        try String(html).write(toFile: URL.documentsDirectory.appending(path: "newsletter2.html"))
    }

    @Test("Generate newsletter 3 html")
    func newsletter3() async throws {
        let html: some HTML = Email.newsletter3()
        try String(html).write(toFile: URL.documentsDirectory.appending(path: "newsletter3.html"))
    }

    @Test("Generate newsletter 4 html")
    func newsletter4() async throws {
        let html: some HTML = Email.newsletter4()
        try String(html).write(toFile: URL.documentsDirectory.appending(path: "newsletter4.html"))
    }
}
