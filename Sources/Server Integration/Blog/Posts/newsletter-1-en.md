# When simplicity backfires: building an elegant bot-proof newsletter system in Swift

When I first launched the newsletter for my Swift-powered website, I thought I had it figured out. The implementation was clean and minimal: users enter their email, click subscribe, and they're done. Simple and effective, or so I thought.

Reality hit fast. Within hours of going live, my inbox was flooded with new "subscriptions" arriving every 20-40 minutes - all of them bots. It became clear that building a secure newsletter system needed more than just a simple form submission. Here's how I solved it using Swift and Vapor.

## The Initial Naive Implementation

Look, we've all been there. You think, "How hard can it be? It's just collecting emails!" So you write some clean Swift code:
1. User types email
2. Click submit
3. Store in database
4. Done!

The code was beautiful. The user experience was frictionless. And the bots? They were having a field day.

## The Swift Solution: Email Verification Flow

After watching the bot parade, I rebuilt the system with proper verification. Here's the elegant (and secure) way, all in Swift:

### 1. The Newsletter Model

First, we need to track subscription states properly:

```swift
public final class Newsletter: Model {
    public static let schema = "newsletter_subscriptions"

    @ID(key: .id)
    public var id: UUID?

    @Field(key: "email")
    public var email: String

    @Field(key: "email_verification_status")
    public var emailVerificationStatus: EmailVerificationStatus

    // A proper enum for status tracking
    public enum EmailVerificationStatus: String, Codable {
        case unverified
        case pending
        case verified
        case failed
    }
}
```

### 2. Verification Tokens

We need single-use, time-limited tokens for verification:

```swift
extension Newsletter {
    public final class Token: Model {
        public static let schema = "newsletter_verification_tokens"
        
        @Field(key: "value")
        public var value: String
        
        @Field(key: "valid_until")
        public var validUntil: Date
        
        // Rate limiting constraints
        static let generationLimit = 5
        static let generationWindow: TimeInterval = 3600 // 1 hour
    }
}
```

### 3. Rate Limiting

Here's where it gets interesting. To stop the bot onslaught, I implemented a rate limiter:

```swift
actor SubscriptionRateLimiter {
    private var attemptsByEmail: [String: AttemptInfo] = [:]
    private let maxAttempts: Int = 5
    private let windowDuration: TimeInterval = 3600 // 1 hour
    
    func subscribe(_ email: String) throws {
        // Check and enforce rate limits
    }
}
```

## The New Flow

Now when someone wants to subscribe:

1. They submit their email
2. System checks rate limits (bye-bye, spam bots)
3. If passed, generates a verification token
4. Sends a verification email
5. Marks subscription as 'pending'
6. User clicks the link
7. System verifies the token and activates the subscription

## Security First, But Keep It Swift-y

The implementation includes several Swift-native security measures:

1. **Rate Limiting**: Using Swift actors for thread-safe attempt tracking
2. **Token Expiration**: Verification links die after 24 hours
3. **One-Time Use Tokens**: Each verification token works exactly once
4. **Email Validation**: Basic format validation before touching the database
5. **Database Constraints**: Unique email constraints because duplicates are no fun

## The Results?

Bot subscriptions? Zero. Legitimate subscribers? They still get through just fine. Yes, it's an extra step for real users, but it's worth it for maintaining a clean subscriber list.

## Lessons Learned

1. **Never Trust User Input**: Even something as simple as a newsletter form needs proper validation
2. **Swift Actors Are Your Friend**: They're perfect for rate limiting and thread-safe state management
3. **Database Models Matter**: Proper status tracking and constraints save headaches later
4. **Type Safety is Beautiful**: Swift's type system makes complex flows manageable

## Clean Architecture: Separating Concerns

Here's where it gets interesting. Instead of cramming everything into one file (we've all been there), I split the newsletter system into distinct modules. Why? Because clean architecture isn't just a buzzword—it makes your code maintainable and testable.

### The Three-Layer Split

```
Coenttb_Newsletter/
├── API/           # How the world talks to us
├── Route/         # How we present ourselves
└── Dependency/    # How we get things done
```

Let's break this down:

1. **API Layer**: This is your public interface. It defines how other services interact with your newsletter system:

```swift
public enum API: Equatable, Sendable {
    case subscribe(Subscribe)
    case unsubscribe(Unsubscribe)
}

extension API {
    public enum Subscribe: Equatable, Sendable {
        case request(Request)
        case verify(Verify)
    }
}
```

2. **Route Layer**: Handles how users interact with your newsletter through URLs:

```swift
public enum Route: Codable, Hashable, Sendable {
    case subscribe(Subscribe)
    case unsubscribe

    public enum Subscribe: Codable, Hashable, Sendable {
        case request
        case verify(Verify)
    }
}
```

3. **Dependency Layer**: This is where the magic happens. All the actual work—sending emails, storing data, verifying tokens—happens here:

```swift
@DependencyClient
public struct Client: @unchecked Sendable {
    public var subscribe: Subscribe
    @DependencyEndpoint
    public var unsubscribe: (EmailAddress) async throws -> Void
}
```

### The Power of Abstraction

Here's the cool part: the newsletter system is a separate package (`Coenttb_Newsletter`). Why does this matter? Because:

1. **Reusability**: Want to add a newsletter to another Swift project? Just import the package.
2. **Testing**: Each layer can be tested independently. No more "it works on my machine" surprises.
3. **Flexibility**: Need to change how emails are sent? Just swap out the dependency implementation.
4. **Clean Dependencies**: The package manages its own dependencies—no need to pollute your main project.

### Real-World Implementation

In practice, it looks something like this:

```swift
// In your main app
import Coenttb_Newsletter

// Set up your routes
app.get("newsletter", "subscribe") { req in
    // Route handles presentation
    return Route.response(
        newsletter: .subscribe(.request),
        htmlDocument: { html in ... },
        subscribeCaption: { "Join our newsletter!" },
        subscribeAction: { yourSubscribeURL },
        // ... other configuration
    )
}

// Handle the API calls
app.post("api", "newsletter", "subscribe") { req in
    // API handles the business logic
    return try await API.response(
        client: yourNewsletterClient,
        logger: req.logger,
        cookieId: "newsletter_subscribed",
        newsletter: .subscribe(.request(...))
    )
}
```

This separation isn't just architectural nitpicking—it makes your code more maintainable and testable. Each piece has a single responsibility, making it easier to understand, modify, and debug.

## What's Next?

While the current system works well, there's always room for improvement:

1. Better analytics for subscription patterns
2. Automated cleanup of unverified subscriptions
3. IP-based rate limiting as an additional layer
4. More detailed error messages for different failure scenarios

## The Takeaway

Sometimes the simplest solution isn't the right one. Yes, building a proper newsletter system took more code than I initially planned. But using Swift's type system and Vapor's elegant API, the implementation remained clean and maintainable.

Remember: in web development, especially with Swift, it's worth taking the time to do things right. Your future self (and your legitimate subscribers) will thank you.

---

*Want to see more about building websites in Swift? Check out the [complete source code](https://github.com/coenttb/coenttb-web) or [subscribe to my newsletter](http://coenttb.com/en/newsletter/subscribe) for more Swift web development insights.*

