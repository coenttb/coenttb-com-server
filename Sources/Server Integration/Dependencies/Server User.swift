//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 18/07/2025.
//

import Dependencies
import Foundation
import Server_Client

extension Client.User: DependencyKey {
    package static var liveValue: Client.User {
        .init()
    }
}
