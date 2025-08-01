//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 12/03/2025.
//

import Coenttb_Server
import Coenttb_Server_Dependencies
import Foundation
import Logging

extension Logger: @retroactive DependencyKey {
    public static var liveValue: Logger {
        @Dependency(\.envVars) var envVars
        let logger = Logger(label: ProcessInfo.processInfo.processName) { _ in
            Coenttb_Server.LogHandler(label: "coenttb.com", logLevel: envVars.logLevel ?? .trace, metadataProvider: nil)
        }
        return logger
    }
}
