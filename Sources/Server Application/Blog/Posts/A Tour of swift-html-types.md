# A Tour of `swift-html-types`

## Introduction: Why Model HTML in Swift?

Picture this: You're building a Swift web application and write what seems like perfectly valid HTML:

```swift
div {
    label { "Username" }
        .attribute("for", "username")
    input()
        .attribute("type", "text")
        .attribute("name", "username")
        .attribute("lable", "username")  // Oops! Typo
}
```

This compiles fine, renders without errors, but your accessibility features mysteriously don't work. Hours later, you discover the typo: `lable` instead of `label`. 

### Problem 1: Strings Everywhere

Traditional HTML generation in Swift treats everything as strings. This means:
- Typos become runtime failures
- No autocomplete for attributes
- Lost HTML semantics (which attributes go with which elements?)
- Painful refactoring

#### Solution to 1: Real Types

What if instead of strings, we had this?

```swift
div {
    label(for: "username") { "Username" }
    input.text(name: "username")
}
```

Now typos are compile errors. Your IDE autocompletes valid attributes. The type system enforces HTML's rules.

### Problem 2: discoverability

```swift
a()
    .attribute("href", "https://example.com")
    .attribute("name", "link to website") // Does an a element even have a name attribute?
    .attribute("download", "true")  // Wait, should this be "true" or "" or a filename?
    .attribute("rel", "noopener noreferrer")  // Is this the right format?
```

Without documentation open, you're guessing what values each attribute can take. Is `download` a boolean attribute or does it take a filename? The HTML spec has answers, but they're buried in thousands of pages.

### Solution 2: Attributes as properties

Instead of forcing developers to remember HTML attribute combinations using string-based methods, each type defines its attributes through its properties.

```swift
// Old way - need to remember attributes and their correct values
a { "Visit Example" }
    .attribute("href", "https://example.com")
    .attribute("target", "_blank")
    .attribute("rel", "noopener noreferrer")  // Security best practice - but who remembers this?

// New way - semantic methods with built-in best practices
a(
    href: "https://example.com",
    rel: [.noopener, .noreferrer],
    target: .blank
) {
    "Visit Example"
}
```

**The magic happens in your IDE:**

When you type `a(` and autocomplete shows you the proper parameters with their types:
- `href: Href?` - The URL to link to
- `target: Target?` - Where to open the link (`.blank`, `.self`, `.parent`, `.top`)
- `rel: [RelType]?` - Relationship types as an array (`.noopener`, `.noreferrer`, `.nofollow`)
- `download: Download?` - Download behavior (`.enabled`, `.filename("report.pdf")`)
- `hreflang: Hreflang?` - Language of the linked resource
- `ping: Ping?` - URLs to notify when link is followed

Each parameter uses proper Swift types that prevent common mistakes:

```swift
// Type-safe target values
a(href: "...", target: .blank) { "Opens in new tab" }
a(href: "...", target: .self) { "Opens in same tab" }

// Relationship types as strongly-typed enums
a(href: "...", rel: [.noopener, .noreferrer]) { "Secure external link" }
a(href: "...", rel: [.nofollow]) { "Don't follow for SEO" }

// Download with type-safe options
a(href: "...", download: .enabled) { "Download with auto-filename" }
a(href: "...", download: .filename("report.pdf")) { "Download as specific filename" }

// Language hints with proper codes
a(href: "...", hreflang: .english) { "English content" }
a(href: "...", hreflang: .french) { "Contenu français" }
```

**Benefits:**
- **Discoverability**: Your IDE shows you what's possible
- **Best practices**: Security and accessibility built-in
- **Correctness**: URL encoding, attribute formats handled automatically
- **Maintainability**: Semantic names make code self-documenting
- **Flexibility**: Still have access to the full initializer when needed

**The Pattern:**
Every HTML element exposes its attributes through its properties. You can extend each HTML element Type with conveniences, like static lets for specific    The factories handle common use cases with sensible defaults, while the initializer provides complete control for edge cases.

This approach scales across all HTML elements - form inputs, media elements, semantic containers, and more. You get the power of HTML with the safety and ergonomics of Swift.

This is `swift-html-types`: a complete model of HTML as Swift types.

Let's explore how it works.

## 2. The Foundation: Core Design Principles
- Domain accuracy: Modeling HTML5 spec faithfully
- Type safety without compromising flexibility
- The balance between completeness and usability

## 3. HTML Elements: Beyond Simple Tags
- The `HTMLElement` protocol and its implementations
- Semantic elements vs. generic containers
- Self-closing elements and their special handling
- Element categories: flow, phrasing, sectioning, etc.

## 4. HTML Attributes: Type-Safe Properties
- Global attributes vs. element-specific attributes
- Attribute value types: strings, booleans, enums
- The naming conflict solution (label element vs. label attribute)
- ARIA attributes and accessibility considerations

## 5. The Architecture: Targets and Products
- Why separate `HTMLElementTypes` and `HTMLAttributeTypes`
- The modular structure and its benefits
- Import strategies for consumers

## 6. Modeling Challenges and Solutions
- Handling HTML's quirks and edge cases
- Optional vs. required attributes
- Deprecated elements and forward compatibility
- The void elements problem

## 7. Type Safety in Practice
- Compile-time validation of HTML structure
- Preventing invalid attribute combinations
- IDE autocomplete and discoverability benefits
- Real-world examples and patterns

## 8. Integration Points
- How `swift-html-types` enables different rendering strategies
- The protocol-based approach for extensibility
- Working with CSS types and other domain models

## 9. Evolution and Maintenance
- Tracking HTML specification changes
- Semantic versioning strategy
- Contributing new elements and attributes
- The stability guarantee

## 10. Comparison with Other Approaches
- String interpolation vs. type-safe builders
- Runtime validation vs. compile-time safety
- Trade-offs and when to use each approach

## 11. Real-World Usage Patterns
- Building forms with type safety
- Creating accessible navigation structures
- Composing complex layouts
- Common pitfalls and how to avoid them

## 12. Future Directions
- HTML Custom Elements support
- Web Components integration
- Performance optimizations
- Community feedback and roadmap

This structure follows the progression from "why" to "what" to "how," similar to your previous posts, while diving deep into the specific design decisions and implementation details of `swift-html-types`. It balances technical depth with practical examples, making it accessible to both library authors and end users.



# [Pitch] Community-maintained HTML and CSS type definitions for Swift

## The Problem

Every Swift web framework reinvents HTML and CSS types:
- Plot has its own element types
- Vapor's Leaf uses strings
- swift-html uses strings for attributes
- Each new library starts from scratch

This fragmentation means:
- No shared tooling between frameworks
- Repeated work modeling the same specs
- Incompatible type definitions
- Lost opportunity for ecosystem growth

## Proposed Solution

What if we had community-maintained packages that provide:
- Complete, spec-compliant HTML element and attribute types
- Complete CSS property and value types
- Just the types—no opinions on rendering or DSL design

Think of it like swift-http-types but for HTML/CSS.

## Questions for the Community

1. Is there interest in shared HTML/CSS type definitions?
2. What would you need from such packages?
3. Would you consider adopting them in your libraries?
4. Should this live under a Swift community organization?

## Proof of Concept

I've created initial implementations:
- [swift-html-types](https://github.com/coenttb/swift-html-types)
- [swift-css-types](https://github.com/coenttb/swift-css-types)

These are working implementations, but I'm happy to transfer ownership, redesign APIs, or merge with existing efforts. The goal is community consensus, not personal ownership.
