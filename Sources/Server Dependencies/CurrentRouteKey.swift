//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 21/02/2025.
//

import Foundation
import Dependencies
import Server_Models
import Coenttb_Com_Router

package enum CurrentRouteKey: DependencyKey {
    package static let testValue: Coenttb_Com_Router.Route? = nil
    package static let liveValue: Coenttb_Com_Router.Route? = nil
}

extension DependencyValues {
    package var route: Coenttb_Com_Router.Route? {
        get { self[CurrentRouteKey.self] }
        set { self[CurrentRouteKey.self] = newValue }
    }
}
