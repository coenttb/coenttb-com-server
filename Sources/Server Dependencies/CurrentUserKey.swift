//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 18-12-2023.
//

import Dependencies
import Foundation
import Server_Models

package enum CurrentUserKey: TestDependencyKey {
    package static let testValue: Server_Models.User? = nil
}

extension DependencyValues {
    package var currentUser: Server_Models.User? {
        get { self[CurrentUserKey.self] }
        set { self[CurrentUserKey.self] = newValue }
    }
}