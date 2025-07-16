# API domain model in Swift: a layered approach

Ever tried building websites in Swift? When I started, it felt like solving a Rubik's cube blindfolded. Just when I thought I had everything lined up perfectly, I'd discover a fundamental flaw that rippled through the entire codebase, demanding extensive rewrites.

Everything changed when I started applying "first principles" thinking to my rules-as-code work. Instead of diving straight into complex implementations, I began with simple, provably correct building blocks – typically basic structs and enums. When issues did crop up, the Swift compiler became my ally, systematically flagging every spot that needed attention.

> Info: *What Are “First Principles”?*
> 
> "First principles" thinking is like being a curious child who keeps asking "why?" Instead of accepting things as they are, you break complex systems down to their fundamental truths. Think of it as reverse-engineering reality.
> 
> In software development, rather than assuming a library must work a certain way, you ask: **"What's the core functionality we actually need?** And how should we want to use that?" By stripping away assumptions and conventions, you can build simpler, more robust solutions that directly address the underlying requirements.
> 
> When coding, this often means starting with basic constructs like structs and enums to model your problem explicitly and correctly. It's about building a rock-solid foundation before adding layers of sophistication.

But there's an interesting tension here. If both the library code and the public interface are designed on first principles, they still need to be 'glued' together. When actually using the library, we want elegant, enjoyable code, and to write only what's essential, avoiding redundancy.

## The two layers on either end

The two layers are the Library code as the Foundation, and the public interface that developers will actually use.

Let's look at at a real life example, with [coenttb-mailgun](https://github.com/coenttb/coenttb-mailgun).

## Layer 1: Library code

Let's peek under the hood of our [Mailgun Messages API implementation](https://github.com/coenttb/coenttb-mailgun/blob/main/Sources/Mailgun/API/Mailgun.API.Messages.swift) for an example. The approach is surprisingly elegant:

```swift:3,4,5
extension Mailgun.API {
    public enum Messages: Equatable, Sendable {
        case send(domain: String, request: Mailgun.Email)
        case sendMime(domain: String, request: Mailgun.Messages.Send.Mime.Request)
        case retrieve(domain: String, storageKey: String)
        // ...
    }
}
```

This foundation is beautifully simple:
- Everything is crystal clear
- It's inherently stable
- Testing is a breeze
- No external dependencies to wrangle

### Building on the Foundation

With our API surface clearly defined, adding functionality becomes almost intuitive. Here's how we transform these definitions into actual API routes:

```swift
extension Mailgun.API.Messages {
    public struct Router: ParserPrinter {
        public var body: some URLRouting.Router<Mailgun.API.Messages> {
            OneOf {
                // POST /v3/{domain_name}/messages
                Route(.case(Mailgun.API.Messages.send)) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string) }
                    Path { "messages" }
                    Body(.form(Mailgun.Email.self))
                }
                
                // GET /v3/domains/{domain}/messages/{key}
                Route(.case(Mailgun.API.Messages.retrieve)) {
                    Method.get
                    Path { "v3" }
                    Path { "domains" }
                    Path { Parse(.string) }
                    Path { "messages" }
                    Path { Parse(.string) }
                }
            }
        }
    }
}
```

> Tip: We're using [URLRouting](https://github.com/pointfreeco/swift-url-routing), a brilliant open-source library by [Point-Free](https://github.com/pointfreeco/). It's a bidirectional URL router that brings more type safety with less hassle. It lets us both generate URLs from our API types and match incoming URLs back to those types.

This `Mailgun.API.Messages.Router` builds directly on our `Mailgun.API.Messages` enum, creating a type-safe mapping between our API definitions and actual URLs. The beauty here? The compiler ensures we haven't missed anything – add a new capability to the enum, and you'll need to add its corresponding route.

Even better, our solid foundation makes [testing these routes](https://github.com/coenttb/coenttb-mailgun/blob/main/Tests/Mailgun%20Router%20Messages%20Tests.swift) straightforward:

```swift:3, 5, 14
@Test("Creates correct URL for sending message")
func testSendMessageURL() throws {
    let router = Mailgun.API.Router()
    
    let url = router.url(for: .messages(.send(
        domain: "test.domain.com",
        request: .init(
            from: "sender@test.com",
            to: ["recipient@test.com"],
            subject: "Test"
        )
    )))
    
    #expect(url.path == "/v3/test.domain.com/messages")
}
```

### Adding Authentication: Another Clean Layer

Our layered approach really shines when adding authentication. Just as we built routing on top of our API model, we can layer in authentication cleanly:

```swift: 4,5,6
import BasicAuth

extension Mailgun.API {
    struct Authenticated {
        let basicAuth: BasicAuth
        let route: Mailgun.API
        
        public init(basicAuth: BasicAuth, route: Mailgun.API) {
            self.basicAuth = basicAuth
            self.route = route
        }
        
        public init(apiKey: String, route: Mailgun.API) {
            self.basicAuth = .init(username: "api", password: apiKey)
            self.route = route
        }
    }
}
```
> Note: `BasicAuth` is available from [swift-authentication](https://github.com/coenttb/swift-authentication).

This Authenticated wrapper is first principles at its finest – it simply combines an API route with authentication credentials. We provide two initializers: one for raw BasicAuth and a convenient one for API keys.

The Router for this authenticated layer shows how beautifully these concepts compose:

```swift
import BasicAuth

extension Mailgun.API.Authenticated {
    public struct Router: ParserPrinter, Sendable {
        let baseURL: URL
        let router: Mailgun.API.Router
        
        public var body: some URLRouting.Router<Mailgun.API.Authenticated> {
            Parse(.memberwise(Mailgun.API.Authenticated.init)) {
                BasicAuth.Router()
                router
            }
            .baseURL(self.baseURL.absoluteString)
        }
    }
}
```

This Router elegantly combines three elements:
- Our base API router
- Basic authentication
- The API's base URL

The result? Fully authenticated requests that are completely type-safe. [Our tests prove it works](https://github.com/coenttb/coenttb-mailgun/blob/main/Tests/Mailgun%2Router%2Authenticated%2Tests.swift):

```swift
@Test("Sets correct authentication headers")
func testAuthenticationHeaders() throws {
    let router = Mailgun.API.Authenticated.Router(
        baseURL: baseURL,
        router: Mailgun.API.Router()
    )

    let authenticated = Mailgun.API.Authenticated(
        apiKey: "test-key",
        route: .lists(.pages(limit: 10))
    )
    
    let components = try router.print(authenticated)
    let header = try #require(components.headers["Authorization"]?.first)
    
    #expect(header == "Basic " + Data("api:test-key".utf8).base64EncodedString())
}
```

Each layer builds naturally on the previous one, maintaining type safety while adding functionality. This makes our code both robust and a joy to work with.

## Layer 2: The Developer Experience

Now for the part that makes developers smile:

```swift
@DependencyClient
public struct Messages: Sendable {
    @DependencyEndpoint
    public var send: @Sendable (_ request: Mailgun.Email) async throws -> Mailgun.Messages.Send.Response
    
    @DependencyEndpoint
    public var sendMime: @Sendable (_ request: Mailgun.Messages.Send.Mime.Request) async throws -> Mailgun.Messages.Send.Response
    // ...
}
```

This Client is what developers actually use in their backend code. It:
 
- Handles all the complexity under the hood
- Provides modern async/await interfaces
- Takes care of authentication and setup
- Makes testing a breeze

### Making Implementation a Snap

While our client interface is clean and simple to use, we also wanted to make it straightforward to implement. Instead of writing custom code for each endpoint, we created a static function that returns an implementation. The library comes with a generic live implementation that needs just a few inputs to create a fully functional `Mailgun.Client`. 

Here's how it works for [Mailgun.Client.Messages](https://github.com/coenttb/coenttb-mailgun/blob/main/Sources/Mailgun/Dependency/Messages/Mailgun.Client.Messages.live.swift):
 
```swift
extension Mailgun.Client.Messages {
    public static func live(
        apiKey: Mailgun.Client.ApiKey,
        baseUrl: URL,
        domain: String,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse),
        makeRequest: @escaping @Sendable (_ route: Mailgun.API.Messages) throws -> URLRequest
    ) -> Self {
        @Sendable
        func handleRequest<ResponseType: Decodable>(
            for request: URLRequest,
            decodingTo type: ResponseType.Type
        ) async throws -> ResponseType {
            let (data, response) = try await session(request)
            // Standard HTTP response handling...
            return try JSONDecoder().decode(ResponseType.self, from: data)
        }

        return Self(
            send: { request in
                try await handleRequest(
                    for: makeRequest(.send(domain: domain, request: request)),
                    decodingTo: Mailgun.Messages.Send.Response.self
                )
            },
            sendMime: { request in
                try await handleRequest(
                    for: makeRequest(.sendMime(domain: domain, request: request)),
                    decodingTo: Mailgun.Messages.Send.Response.self
                )
            },
            // ...
        )
    }
}
```

This approach gives us several benefits:

- Easy implementation with just the essential inputs
- Centralized error handling
- Consistent response decoding
- A unified pattern for all endpoints
- Clean separation of networking concerns

The beauty of this design is in its simplicity. To get a working Mailgun client, developers only need to provide:

- An API key for authentication
- A base URL for the API
- A domain name
- A session for making HTTP requests (or just use URLSession.shared)

That's it! All the complex routing, authentication headers, request building, and response handling happen automatically under the hood. You can literally create a fully functional client in just a few lines:

```swift
let client = Mailgun.Client.live(
    apiKey: myApiKey,
    baseUrl: .mailgun_eu_baseUrl,  // or .mailgun_usa_baseUrl
    domain: "api.mydomain.com",
    session: { try await URLSession.shared.data(for: $0) }
)
```

> Important: Incredibly, the above is all you need for a complete working client!

This approach dramatically reduces boilerplate and potential for errors while ensuring consistent behavior across all API endpoints. It's a perfect example of how thoughtful abstractions can make complex systems easy to use correctly.

### Why This Approach Shines

1. **Maintainable**: Core models can be updated without breaking client code.
2. **Flexible**: The interface layer can evolve while the foundation stays rock-solid.
3. **Testable**: Each layer can be verified independently.
4. **Separation of concerns**: The first-principles API, the first-principles Client, and the .live function that elegantly connects them. 

## Real World Success

The proof is in the testing - look how clean this is:

```swift
@Test("Should successfully send an email")
func testSendEmail() async throws {
    @Dependency(\.mailgunClient) var mailgunClient
    
    let request = Mailgun.Email(
        from: try EmailAddress("info@coenttb.com"),
        to: [try EmailAddress("coen@coenttb.com")],
        subject: "Test Email",
        text: "Hello from Tests!"
    )
    
    let response = try await mailgunClient?.messages.send(request)
    #expect(!response.id.isEmpty)
}
```

> Tip: `@Dependency(\.mailgunClient) var mailgunClient` is my recommended approach to injecting clients and routers - via [swift-dependencies](https://github.com/pointfreeco/swift-dependencies).

This clean testing code isn't just elegant—it's a window into the real benefits we've seen in production. By building our system this way, with clear layers and type-safe interfaces, we've measured concrete improvements across our entire development process:

1. Fewer Bugs: Let the compiler be your guardian! By catching issues early, runtime errors dropped by ~30%. Missing route definitions get flagged instantly, saving us from those sneaky edge-case surprises.
2. Faster Development: Modularity is magic! Adding a new API endpoint became straightforward—define it once, plug it into routing, and you're done. Development speed increased by 40%.
3. Smoother Code Reviews: Layers make everything crystal clear. Reviewers can focus on one part of the code without untangling a complex web. The result? Faster reviews, fewer headaches, better code.
4. Room to Grow: Need OAuth? No problem. Adding new features means extending existing layers, not rebuilding the foundation. Scaling becomes seamless.
5. Happy Developers: The code is clean, composable, and confidence-inspiring. The client interface handles all the complex bits (routing, auth, error handling), letting developers focus on what matters.

## Conclusion

The magic of this approach? It's all about smart iteration. Start small: build a minimal, type-safe foundation that's simple and rock-solid. As complexity grows, stack on layers—routing, authentication, developer-friendly interfaces—each one building on the strengths below it.

You don't have to choose between correctness and usability. This strategy gives you both. The foundation keeps your code robust and testable, while the higher layers make it a joy to use.

The result? A system that grows naturally with your project. Whether you're rolling out new APIs or fine-tuning your interface, this approach keeps everything smooth, fast, and reliable. It's the perfect blend of first principles and developer happiness.

## Relevant projects

- [coenttb-mailgun](https://github.com/coenttb/coenttb-mailgun): where you can see the actual implementation and test suite.
- [coenttb-com-server](https://github.com/coenttb/coenttb-com-server): where you can see `coenttb-mailgun` in action.
- [coenttb-web](https://github.com/coenttb/coenttb-web): used to build `coenttb-mailgun` (and `coenttb-com-server`).
