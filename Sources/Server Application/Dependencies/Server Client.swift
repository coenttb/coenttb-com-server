//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 12/03/2025.
//

import Coenttb_Server
import Coenttb_Blog
import Coenttb_Newsletter
import Coenttb_Newsletter_Live
import Mailgun
import Server_Client
import Server_Dependencies
import Server_Models
import Coenttb_Com_Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Server_Client.Client: DependencyKey {
    package static var liveValue: Server_Client.Client {
        .init(
            newsletter: .liveValue,
            identity: .live(),
            user: .init()
        )
    }
}
