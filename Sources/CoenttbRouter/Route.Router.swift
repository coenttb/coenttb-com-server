import Coenttb_Web
import Dependencies
import Foundation

extension Route {
    public struct Router: ParserPrinter & Sendable {
        let baseURL: URL

        package init(_ baseURL: URL) {
            self.baseURL = baseURL
        }

        public var body: some URLRouting.Router<Route> {
            OneOf {
                URLRouting.Route(.case(Route.website)) {
                    Coenttb_Web.Website.Router.init(pageRouter: Route.Website.Router())
                }

                URLRouting.Route(.case(Route.public)) {
                    Public.Router()
                }
                URLRouting.Route(.case(Route.api)) {
                    API.Router()
                }
                URLRouting.Route(.case(Route.webhook)) {
                    Webhook.Router()
                }
            }.baseURL(self.baseURL.absoluteString)
        }

        public func href(for public: Route.Public) -> String {
            self.url(for: .public(`public`)).relativePath
        }

        public func href(for website: Coenttb_Web.Website<Website>) -> String {
            self.url(for: website).relativePath
        }

        public func url(for page: Coenttb_Web.Website<Website>) -> URL {
            return self.url(for: .website(page))
        }

        public func url(for page: Route.Website) -> URL {
            @Dependency(\.language) var language
            return self.url(for: .website(.init(language: language, page: page)))
        }

        public func href(for page: Route.Website) -> String {
            @Dependency(\.language) var language
            return self.url(for: .website(.init(language: language, page: page))).relativePath
        }
    }
}
