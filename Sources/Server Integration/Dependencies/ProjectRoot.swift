//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 12/03/2025.
//

import Coenttb_Blog
import Coenttb_Com_Shared
import Coenttb_Identity_Consumer
import Coenttb_Newsletter
import Coenttb_Newsletter_Live
import Coenttb_Server
import Mailgun
import Server_Client
import Server_Dependencies
import Server_Models

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ProjectRootKey: @retroactive DependencyKey {
    public static var liveValue: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}
