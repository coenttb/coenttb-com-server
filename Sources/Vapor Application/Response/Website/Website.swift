//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 17-12-2023.
//

import Coenttb_Vapor
import Server_Dependencies
import Coenttb_Com_Shared
import Coenttb_Com_Router

extension Website<WebsitePage> {
    static func response(
        website: Website<WebsitePage>
    ) async throws -> any AsyncResponseEncodable {

        @Dependency(\.envVars.languages) var languages
        @Dependency(\.request) var request

        return try await withDependencies {
            let language = website.language ?? (request?.locale).flatMap { Languages.Language(locale: $0) } ?? .english
            $0.language = language
            $0.locale = request?.locale ?? $0.locale            
            $0.route = .website(.init(language: language, page: website.page))
            $0.languages = [.english, .dutch]
        } operation: {
            return try await WebsitePage.response(page: website.page)
        }
    }
}
