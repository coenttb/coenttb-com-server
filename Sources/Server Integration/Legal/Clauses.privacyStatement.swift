//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 21/06/2024.
//

import Coenttb_Server_HTML
import CoenttbMarkdown
import Dependencies
import Languages

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Clauses {
    nonisolated(unsafe)
    package static let privacyStatement: Translated<Self> = .init { language in
        withDependencies {
            $0.language = language
        } operation: {
            Clauses.privacyStatement(entity: (name: "coenttb", ()))
        }
    }
}
