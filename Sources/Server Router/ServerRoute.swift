//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 10/08/2022.
//

import CasePaths
import CoenttbServerRouter
import Dependencies
import Foundation
import Languages
import URLRouting

public typealias ServerRoute = CoenttbServerRoute<
    API,
    WebsitePage,
    Public,
    Webhook
>
