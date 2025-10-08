//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 21/02/2025.
//

import CoenttbRouter
import Dependencies
import Foundation
import Server_Models

package enum CurrentRouteKey: DependencyKey {
    package static var testValue: Coenttb_Com_Router.Route? { nil }
    package static var liveValue: Coenttb_Com_Router.Route? { nil }
}

extension DependencyValues {
    package var route: Coenttb_Com_Router.Route? {
        get { self[CurrentRouteKey.self] }
        set { self[CurrentRouteKey.self] = newValue }
    }
}
