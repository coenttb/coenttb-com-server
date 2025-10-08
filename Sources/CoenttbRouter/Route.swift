//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 10/08/2022.
//

import CasePaths
import Coenttb_Server
import Coenttb_Web
import Foundation
import Translating

@CasePathable
@dynamicMemberLookup
public enum Route: Equatable, Sendable {
    case website(Coenttb_Web.Website<Website>)
    case `public`(Public)
    case webhook(Webhook)
    case api(API)
}

extension Route {
    public static func page(
        language: Language,
        _ page: Website
    ) -> Self {
        return .website(.init(language: language, page: page))
    }
}

extension Route {
    public static func page(
        _ page: Website
    ) -> Self {
        @Dependency(\.language) var language
        return .website(.init(language: language, page: page))
    }
}
