//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 21/06/2024.
//

import CoenttbMarkdown
import CoenttbWebHTML
import Dependencies
import Foundation
import Languages

extension Clauses {
    nonisolated(unsafe)
    public static let privacyStatement: Translated<Self> = .init { language in
        withDependencies {
            $0.language = language
        } operation: {
            Clauses.privacyStatement(entity: (name: "coenttb", ()))
        }
    }
}
