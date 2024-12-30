//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 17-12-2023.
//

import Coenttb_Server_HTML
import Coenttb_Server_Models
import Dependencies
import Foundation
import Language
import Languages
import Server_Dependencies
import Server_Router
import Vapor

extension Website<WebsitePage> {
    static func response(
        website: Website<WebsitePage>
    ) async throws -> any AsyncResponseEncodable {

        @Dependency(\.envVars.languages) var languages
        @Dependency(\.request) var request

        return try await withDependencies {
            $0.route = .website(website)
            $0.locale = request?.locale ?? $0.locale
            $0.language = website.language ?? (request?.locale).flatMap { Languages.Language(locale: $0) } ?? .english
            $0.languages = [.english, .dutch]
        } operation: {
            return try await WebsitePage.response(page: website.page)
        }
    }
}
