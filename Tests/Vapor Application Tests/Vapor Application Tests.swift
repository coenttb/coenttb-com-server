import Coenttb_Com_Router
import Coenttb_Com_Shared
import ServerFoundationVapor
import DependenciesTestSupport
import FluentPostgresDriver
import Queues
import QueuesFluentDriver
import Server_Client
import Server_EnvVars
import Server_Integration
import Server_Models
import Testing
@testable import Vapor_Application
import VaporTesting

@Suite(
    .dependency(\.envVars, .liveValue)
)
struct RouterLoadTests {
    @Test
    func testMultipleHomeRequests() async throws {

        try await withDependencies {
            $0.envVars = .liveValue
        } operation: {
            try await withApp { app in
                // Configure your router
                @Dependency(\.coenttb.website.router) var router

                app.mount(serverRouter, use: Coenttb_Com_Router.Route.response)

                // Create test client
                let client = try app.testing()

                // Number of concurrent requests
                let requestCount = 100

                // Create array to store async operations
                var requests: [Task<any TestingApplicationTester, any Error>] = []

                // Create multiple concurrent requests
                for i in 0..<requestCount {
                    let task = Task {
                        try await client.test(.GET, "/") { req in
                            // Configure request if needed
                            req.headers.add(name: "X-Request-ID", value: "test-\(i)")
                        } afterResponse: { response in
                            // Validate response
                            #expect(response.status == .ok)
                            #expect(response.body.string.contains("Home page"))

                            // Add any other response validations
                            #expect(response.headers.first(name: "content-type")?.contains("text/html") == true)
                        }
                    }
                    requests.append(task)
                }

                // Wait for all requests to complete
                try await withThrowingTaskGroup(of: Void.self) { group in
                    for request in requests {
                        group.addTask {
                            try await request.value
                        }
                    }
                    try await group.waitForAll()
                }

                // Verify application state after load test
                // Add any assertions about the application's state here
            }
        }

    }

    @Test(.disabled())
    func testDifferentRoutes() async throws {
        try await withApp { app in
            app.mount(Server_Router.API.Router.shared) { _, _, _ in
                // Your route handling logic
                return Response(status: .ok)
            }

            let client = try app.testing()
            let routes = [
                "/v1/account/login",
                "/v1/newsletter/subscribe",
                "/v1/rss/feed"
                // Add more routes to test
            ]

            try await withThrowingTaskGroup(of: Void.self) { group in
                for route in routes {
                    group.addTask {
                        try await client.test(.GET, route) { _ in
                            // Configure request
                        } afterResponse: { response in
                            #expect(response.status == .ok)
                        }
                    }
                }
                try await group.waitForAll()
            }
        }
    }

    // Helper method to simulate varying load patterns
    private func executeWithLoadPattern(
        app: Application,
        requestsPerSecond: Int,
        duration: TimeInterval,
        route: String
    ) async throws {
        let client = try app.testing()
        let startTime = Date()

        while Date().timeIntervalSince(startTime) < duration {
            try await withThrowingTaskGroup(of: Void.self) { group in
                for _ in 0..<requestsPerSecond {
                    group.addTask {
                        try await client.test(.GET, route) { _ in
                            // Configure request
                        } afterResponse: { response in
                            #expect(response.status == .ok)
                        }
                    }
                }
                try await group.waitForAll()
            }
            try await Task.sleep(nanoseconds: 1_000_000_000) // Wait 1 second
        }
    }
}
