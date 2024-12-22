//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 02/09/2024.
//

import Dependencies
import Foundation

private enum ProjectRootKey: TestDependencyKey {
    static let testValue: URL = {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }()
}

extension ProjectRootKey: DependencyKey {
    static let liveValue: URL = {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }()
}


extension DependencyValues {
    public var projectRoot: URL {
        get { self[ProjectRootKey.self] }
        set { self[ProjectRootKey.self] = newValue }
    }
}
