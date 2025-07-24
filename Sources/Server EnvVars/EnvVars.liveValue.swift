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
// import Coenttb_Stripe

extension EnvVars: @retroactive DependencyKey {
    public static var liveValue: Self {
        var localEnvFile: URL? {
#if DEBUG
            @Dependency(\.projectRoot) var projectRoot
            let envFile = projectRoot.appendingPathComponent(".env.development")
            return FileManager.default.fileExists(atPath: envFile.path) ? envFile : nil
#else
            return nil
#endif
        }
        return try! EnvVars.live(
            localEnvFile: localEnvFile
        )
    }
}
