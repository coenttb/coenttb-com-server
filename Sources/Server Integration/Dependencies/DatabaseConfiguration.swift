//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 23/07/2025.
//

import Dependencies
import Coenttb_Server_Dependencies

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension DatabaseConfiguration: @retroactive DependencyKey {
    public static var liveValue: Self { .default }
}
