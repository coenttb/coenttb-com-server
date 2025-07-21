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
import CoenttbHTML
@testable import Server_Integration
import Testing

@Suite(
    "Emails Tests",
    .dependency(\.color, .coenttb),
    .dependency(\.date, .init(Date.init)),
    .dependency(\.calendar, .autoupdatingCurrent),
    .dependency(\.coenttb, .liveValue)
)
struct EmailsTests {


//    @Test("Generate newsletter 2 html")
//    func newsletter2() async throws {
//        let html: some HTML = Email.newsletter2()
//        try String(html).write(toFile: URL.documentsDirectory.appending(path: "newsletter2.html"))
//    }
//
//    @Test("Generate newsletter 3 html")
//    func newsletter3() async throws {
//        let html: some HTML = Email.newsletter3()
//        try String(html).write(toFile: URL.documentsDirectory.appending(path: "newsletter3.html"))
//    }
//
//    @Test("Generate newsletter 4 html")
//    func newsletter4() async throws {
//        let html: some HTML = Email.newsletter4()
//        try String(html).write(toFile: URL.documentsDirectory.appending(path: "newsletter4.html"))
//    }
//    
//    @Test("Generate newsletter 5 html")
//    func newsletter5() throws {
//        let html: some HTML = Email.newsletter5()
//        try String(html).write(toFile: URL.documentsDirectory.appending(path: "newsletter5.html"))
//    }
    
    @Test("Generate newsletter 6 html")
    func newsletter6() throws {
        try AppleEmail.init(
            emailDocument: Email.newsletter6(),
            from: "newsletter@mg.coenttb.com",
            subject: "coenttb #6 Modern Swift Library Architecture: 3 Testing a composition of packages",
            date: .init(year: 2025, month: 7, day: 21, hour: 18, minute: 0)!
        )
        .description
        .write(toFile: URL.documentsDirectory.appending(path: "newsletter6.eml"))
    }
}
