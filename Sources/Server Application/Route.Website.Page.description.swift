//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 10/12/2024.
//

import Dependencies
import Foundation
import Languages
import Server_Dependencies
import Coenttb_Com_Shared
import Server_Translations
import Coenttb_Com_Shared
import Coenttb_Com_Router

extension Route.Website {
    public func description() -> TranslatedString? {

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
        default: ""
        }

        return x?.capitalizingFirstLetter()
    }
}
