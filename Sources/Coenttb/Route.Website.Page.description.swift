//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 10/12/2024.
//

import Dependencies
import Foundation
import Languages
import MemberwiseInit
import ServerDependencies
import ServerRouter
import ServerTranslations

extension WebsitePage {
    public func description() -> TranslatedString? {

        let x: TranslatedString? = switch self {
        case .choose_country_region:
            Coenttb.oneliner
        case .home:
            Coenttb.oneliner
        case .privacy_statement:
            Coenttb.oneliner
        case .blog(.index):
            Coenttb.oneliner
        case .blog(.post):
            Coenttb.oneliner
        case .terms_of_use:
            Coenttb.oneliner
        case .general_terms_and_conditions:
            Coenttb.oneliner
        case .newsletter:
            Coenttb.oneliner
        case .contact:
            Coenttb.oneliner
        default: ""
        }

        return x?.capitalizingFirstLetter()
    }
}
