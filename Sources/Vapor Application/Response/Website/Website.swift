//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 17-12-2023.
//

import CoenttbRouter
import CoenttbShared
import Coenttb_Vapor
import Server_Dependencies

extension Website<Coenttb_Com_Router.Route.Website> {
    static func response(
        website: Website<Coenttb_Com_Router.Route.Website>
    ) async throws -> any AsyncResponseEncodable {
        @Dependency(\.request) var request

        return try await withDependencies {
            let language = website.language ?? (request?.locale).flatMap { Translating.Language(locale: $0) } ?? .english
            $0.language = language
            $0.locale = request?.locale ?? $0.locale
            $0.route = .website(.init(language: language, page: website.page))
            $0.languages = .init($0.envVars.languages ?? [.english, .dutch])
        } operation: {
            return try await Coenttb_Com_Router.Route.Website.response(page: website.page)
        }
    }
}
