//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 20/05/2024.
//

import Coenttb_Com_Router
import Server_Translations
import Foundation

extension Route.Website {
    package var title: TranslatedString? {
        switch self {
        case .choose_country_region:
            return String.choose_country_region
        case .home:
            return nil
        case .privacy_statement:
            return String.privacyStatement
        case .blog(.index):
            return String.blog + String.space + "Index"
        case let .blog(.post(string)):
            return String.blog + String.space + "\(string)"
        case .terms_of_use:
            return String.terms_of_use
        case .general_terms_and_conditions:
            return String.general_terms_and_conditions + " " + TranslatedString(dutch: "geraadpleegd op", english: "consulted on ") + "\(Date().description(dateStyle: .full, timeStyle: .long))"
        case .contact:
            return String.contact
        case .newsletter:
            return String.newsletter
        case .projects:
            return "projects"
        }
    }
}
