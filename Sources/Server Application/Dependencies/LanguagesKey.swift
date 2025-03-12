//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 12/03/2025.
//

import Coenttb_Server

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension LanguagesKey: @retroactive DependencyKey {
    public static var liveValue: Set<Language> {
        @Dependency(\.envVars.languages) var languages
        return languages.map(Set.init) ?? .allCases
    }
}
