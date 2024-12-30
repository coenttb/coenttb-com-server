//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 11/09/2024.
//

import CasePaths
import Coenttb_Server_Router
import Coenttb_Identity
import Dependencies
import Foundation
import Languages
import Server_Translations
import URLRouting

extension WebsitePage {
    @CasePathable
    public enum Account: Codable, Hashable, Sendable {
        case index
        case settings(WebsitePage.Account.Settings)
        case create(Coenttb_Identity.Route.Create)
        case delete
        case login
        case logout
        case password(Coenttb_Identity.Route.Password)
        case emailChange(Coenttb_Identity.Route.EmailChange)
    }
}

extension WebsitePage.Account {
    struct Router: ParserPrinter {
        var body: some URLRouting.Router<WebsitePage.Account> {
            OneOf {

                Route(
                    .convert(
                        apply: WebsitePage.Account.init,
                        unapply: Coenttb_Identity.Route.init
                    )
                ) {
                    Coenttb_Identity.Route.Router()
                }

                Route(.case(WebsitePage.Account.settings)) {
                    Path { "settings" }
                    WebsitePage.Account.Settings.Router()
                }

                Route(.case(WebsitePage.Account.index))
            }
        }
    }
}

extension WebsitePage.Account {
    fileprivate init(_ accountRoute: Coenttb_Identity.Route) {
        switch accountRoute {
        case .create(let create):
            self = .create(create)
        case .delete:
            self = .delete
        case .login:
            self = .login
        case .logout:
            self = .logout
        case .password(let password):
            self = .password(password)
        case .emailChange(let emailChange):
            self = .emailChange(emailChange)
        }
    }
}

extension Coenttb_Identity.Route {
    package init?(_ accountRoute: WebsitePage.Account) {
        switch accountRoute {
        case .create(let create):
            self = .create(create)
        case .delete:
            self = .delete
        case .login:
            self = .login
        case .logout:
            self = .logout
        case .password(let password):
            self = .password(password)
        case .emailChange(let emailChange):
            self = .emailChange(emailChange)
        case .settings, .index:
              return nil
        }
    }
}

extension WebsitePage.Account {
    public enum Settings: Codable, Hashable, Sendable {
        case index
        case profile
    }
}

extension WebsitePage.Account.Settings {
    struct Router: ParserPrinter {
        var body: some URLRouting.Router<WebsitePage.Account.Settings> {
            OneOf {
                URLRouting.Route(.case(WebsitePage.Account.Settings.index)) {
                    Path { "index" }
                }

                URLRouting.Route(.case(WebsitePage.Account.Settings.profile)) {
                    Path { "profile" }
                }
            }
        }
    }
}
