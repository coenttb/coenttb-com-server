//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 10/12/2024.
//

import Coenttb_Com_Router
import Coenttb_Com_Shared
import Dependencies
import Foundation
import Server_Dependencies
import Server_Translations
import Translating

extension Coenttb_Com_Router.Route.Website {
    package func description() -> TranslatedString? {

        let x: TranslatedString? = switch self {
        case .choose_country_region:
            String.oneliner
        case .home:
            String.oneliner
        case .privacy_statement:
            String.oneliner
        case .blog(.index):
            String.oneliner
        case .blog(.post):
            String.oneliner
        case .terms_of_use:
            String.oneliner
        case .general_terms_and_conditions:
            String.oneliner
        case .newsletter:
            String.oneliner
        case .contact:
            String.oneliner
        case .projects:
            "projects"
        }

        return x?.capitalizingFirstLetter()
    }
}
