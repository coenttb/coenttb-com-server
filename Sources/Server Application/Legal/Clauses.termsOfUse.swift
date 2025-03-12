//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 21/06/2024.
//

import CoenttbMarkdown
import Coenttb_Server_HTML
import Dependencies
import Languages
import Coenttb_Legal_Documents

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Clauses {
    nonisolated(unsafe)
    package static let termsOfUse: Translated<Self> = {
        return .init { language in
            withDependencies {
                $0.language = language
            } operation: {
                Clauses.termsOfUse(entity: (name: "coenttb", ()))
            }
        }
    }()
}
