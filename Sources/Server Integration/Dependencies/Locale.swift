//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 12/03/2025.
//

import Dependencies
import Translating

extension LanguagesKey: @retroactive DependencyKey {
    public static var liveValue: Set<Language> {
        @Dependency(\.envVars.languages) var languages
        return languages.map(Set.init) ?? .allCases
    }
}
