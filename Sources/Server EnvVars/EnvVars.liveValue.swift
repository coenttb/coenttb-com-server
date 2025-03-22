//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 11/03/2025.
//

import Coenttb_Server
import EnvironmentVariables
import GoogleAnalytics
import Hotjar
import Mailgun
import Postgres
//import Coenttb_Stripe

extension EnvVars: @retroactive DependencyKey {
    public static var liveValue: Self {
        var localDevelopment: URL? {
#if DEBUG
            @Dependency(\.projectRoot) var projectRoot
            return projectRoot.appendingPathComponent(".env.development")
#else
            return nil
#endif
        }
        return try! EnvVars.live(
            localDevelopment: localDevelopment
        )
    }
}
