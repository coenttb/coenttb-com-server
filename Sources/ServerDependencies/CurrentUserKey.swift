//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 18-12-2023.
//

import Dependencies
import Foundation
import ServerModels

public enum CurrentUserKey: TestDependencyKey {
    public static let testValue: User? = nil
}

extension DependencyValues {
    public var currentUser: User? {
        get { self[CurrentUserKey.self] }
        set { self[CurrentUserKey.self] = newValue }
    }
}
