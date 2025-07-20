# Modern Swift Library Architecture 3: Testing a composition of packages

> NOTE: 
> This is Part 3 in a series exploring modern swift library architecture. 
> 
> While the ideas in this article are my own, I've used AI to draft it—hope you don't mind the em-dashes (-).

## What makes testing feel like a chore?

Picture this: you're maintaining a Swift library and need to add a new feature. You write the code, then turn to the tests... and groan. The test suite is a tangled mess where changing one thing breaks tests in completely unrelated areas. Sound familiar?

I used to think this was just the nature of testing. Then I built the `swift-html` ecosystem as five focused packages instead of one monolith, and something interesting happened—writing tests became almost trivial. Each package had such a clear purpose that the tests practically wrote themselves.

Let me show you what I discovered, using real-world examples. We will finish by adding dark mode support that touched multiple conceptual areas but required surprisingly few test changes.

> RECAP:
> Our ecosystem consists of three independent leaf packages ([swift-html-types](https://github.com/coenttb/swift-html-types), [swift-css-types](https://github.com/coenttb/swift-css-types), [pointfree-html](https://github.com/coenttb/pointfree-html)), integrated through [swift-html-css-pointfree](https://github.com/coenttb/swift-html-css-pointfree), with additional features in [swift-html](https://github.com/coenttb/swift-html). Each package has a specific, focused responsibility.

## The principle that changes everything

Before we dive into code, there's one principle that made all the difference: **test what you own, trust what you import**.

What does this mean in practice?
- Each package tests only its direct responsibilities
- We assume our dependencies work correctly (they have their own tests!)
- Integration tests verify connections, not implementations
- The compiler helps enforce these boundaries

When your architecture has clear boundaries, this principle happens naturally. You literally can't test what you don't own because you don't have access to the internals. It's not a rule you enforce—it's just how the code works.

## Starting with the leaf packages

Let's start with our leaf packages—the ones with no dependencies. These are surprisingly satisfying to test because they're just pure Swift types doing one thing well.

### The protocol-first approach in `swift-html-types`

Here's something I discovered while building `swift-html-types`: many HTML attributes share common behavior through protocols. So why test that behavior 50 times?

```swift
import Testing
import HTMLAttributeTypes

@Suite("StringAttribute Protocol Tests")
struct StringAttributeProtocolTests {
    struct TestAttribute: StringAttribute {
        static let name = "test"
    }
        
    @Test("String attributes serialize to their string value")
    func basicSerialization() {        
        let attr = TestAttribute()
        #expect(attr.name == "test")
    }
}
```

*This test suite tests the Attribute protocol using a mock implementation ('TestAttribute'). Now we don't have to test this for each implementation. Pretty sweet.*

Now when I test individual attributes, I focus only on what makes them unique:

```swift
import Testing
import HTMLAttributeTypes

@Suite("Class Attribute Tests")
struct ClassTests {
    @Test("Class combines multiple values with spaces")
    func multipleValues() {
        let classes = Class("header", "large", "primary")
        #expect(classes.value == "header large primary")
    }
    
    @Test("Class deduplicates values") 
    func deduplication() {
        let classes = Class("nav", "nav", "primary")
        #expect(classes.value == "nav primary")
    }
    
    @Test("Class handles empty values")
    func emptyHandling() {
        let classes = Class("", "nav", "", "primary")
        #expect(classes.value == "nav primary")
    }
}
```

*This test suite tests just the Class struct, and we don't have to repeat the Attribute tests for Class. Pretty sweet.*

> NOTE: We DON'T test basic string serialization - that's covered by StringAttribute Tests.

This approach scales beautifully. With 50+ attribute types, we test the shared string behavior once, then each attribute only tests what makes it special. When we add a new string-based attribute, the basic serialization is already tested—we just add tests for its unique behavior.

### An unexpected benefit: speed

Here's something I didn't anticipate: these focused tests are incredibly fast. The HTMLAttributeTypes test suite with 200+ tests completes in under 0.1 seconds on my Macbook Air. Why? Because they're testing pure functions with no dependencies—no rendering, no CSS parsing, no file I/O.

In a monolithic architecture, every test potentially exercises the entire stack. Not only are those tests slower, they're also more fragile because they have more moving parts.

## Testing the rendering layer

The `pointfree-html` package needs to test it correctly renders HTML. For this, I use [snapshot testing](https://github.com/pointfreeco/swift-snapshot-testing):

```swift
import Testing
import SnapshotTesting
import Html

@Test("Elements render with correct structure")
func elementStructure() {
    assertInlineSnapshot(
        of: HTMLTag("div") {
            HTMLTag("h1") { "Welcome" }
            HTMLTag("p") { "Hello, world!" }
        }, 
        as: .html
    ) {
        """
        <div>
          <h1>Welcome</h1>
          <p>Hello, world!</p>
        </div>
        """
    }
}
```

*The snapshot test inserts the rendered HTML inline in the closure. And it's rendering perfectly! Nice.* 

The pointfree-html tests use generic `HTMLTag` types, not `swift-html-types`' `ContentDivision` or `Heading1` types. That's because pointfree-html doesn't know about those types—it just knows how to render anything conforming to the `HTML` protocol. This separation lets both packages evolve independently.

## Where it all comes together: integration testing

The `swift-html-css-pointfree` package connects our type packages with the rendering engine. 

> INFO:
> 
> Integrating HTMLElementTypes with PointFreeHTML is just adding a method to each HTMLElementType to return an PointFreeHTML.HTMLElement. That HTMLElement can then be rendered with PointFreeHTML. 
> 
> ```swift
> import HTMLElements
> import PointFreeHTML
> 
> extension HTMLElementTypes.Anchor {
>     public func callAsFunction(
>         @HTMLBuilder _ content: () -> some PointFreeHTML.HTML
>     ) -> some PointFreeHTML.HTML {
>         PointFreeHTML.HTMLElement(tag: Self.tag) { content() }
>             .attributionSrc(self.attributionsrc)
>             .download(self.download)
>             .href(self.href)
>             .hreflang(self.hreflang)
>             .ping(self.ping)
>             .referrerPolicy(self.referrerpolicy)
>             .rel(self.rel)
>             .target(self.target)
>     }
> }

> INFO:
>
> Integrating CSSTypes with `PointFreeHTML` is just adding a method to the `PointFreeHTML.HTML` protocol to return an `HTMLInlineStyle` that is used to render that element *with styles* with PointFreeHTML. 
>  
> ```swift
> import CSSTypes
> import PointFreeHTML
> 
> extension HTML {
>     @discardableResult
>     public func color(
>         _ color: CSSPropertyTypes.Color?,
>         media: CSSAtRuleTypes.Media? = nil,
>         pre: String? = nil,
>         pseudo: Pseudo? = nil
>     ) -> HTMLInlineStyle<Self> {
>         self.inlineStyle(color, media: media, pre: pre, pseudo: pseudo)
>     }
> }
> ```

You might expect complex integration tests, but they're surprisingly simple:

```swift
@Suite("HTML+CSS+PointFree Integration")
struct IntegrationTests {
    @Test("CSS classes apply to HTML elements")
    func htmlCssPointFreeIntegration() {        
        assertInlineSnapshot(
          of: HTMLDocument { 
            Anchor(href: "#").color(.red) { "click here" }
          }, 
          as: .html
        ) {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                .color-dMYaj4{color:red}
                </style>
              </head>
              <body>
                <a href="#" class="color-dMYaj4">click here</a>
              </body>
            </html>
        }
    }
}
```

*The snapshot test shows our Anchor element is rendering perfectly with both the  attribute and the color styling! Awesome.* 

All we do is verify that the HTML element is generated and that it has the correct styling applied. Snapshot testing is perfect for this!

Look at what we're NOT testing here:
- That `Anchor` is a valid HTML element and that its properties are well constructed (`swift-html-types` already tests this)
- That `Color.red` produces valid CSS (`swift-css-types` handles that)
- That HTML rendering works (`pointfree-html` covers it)

We only verify that these pieces connect correctly. That's it. When each package thoroughly tests its own responsibilities, integration tests can focus solely on the integration.

> NOTE: We can’t use `swift-html`’s conveniences here, since the integration layer has no awareness of these higher-level developer conveniences. For example, in `swift-html` you can write `a(href: "#") { "click here" }.color(.red)`, but that typealias isn’t available to the integration layer.

## When tests fail, you know exactly where to look

In a monolithic system, a failing test sends you on a debugging adventure through thousands of lines of code. But with this modular approach, failures are specific:

- HTMLAttributeTests failing? The problem is in attribute logic.
- CSSTypes Tests failing? CSS validation broke.
- Integration Tests failing? The glue between packages needs fixing.
- Only one package has failures? You've already narrowed down the problem.

I've fixed complex bugs in minutes because the test failure immediately pointed to the specific package and module responsible. No archaeology required.

## The real test: adding dark mode

Let me show you what convinced me this architecture actually works. I needed to add dark mode support—a feature that conceptually spans HTML elements, CSS properties, and rendering logic.

In a monolithic architecture, this would touch dozens of files, break tests everywhere, and leave you wondering if you caught all the edge cases. Here's what actually happened:

### The implementation

```swift
// In swift-html package
extension HTML {
    public func color(light: CSSPropertyTypes.Color, dark: CSSPropertyTypes.Color) -> some HTML {
        self
            .color(light)
            .color(dark, media: .prefersColorScheme(.dark))
    }
}
```

### The tests

```swift
@Suite("Dark Mode Support")
struct DarkModeTests {
    @Test("Adaptive colors generate appropriate classes and styles")
    func adaptiveColorGeneration() {
        assertInlineSnapshot(
            of: HTMLDocument {
                div { "Hello" }.color(light: .blue, dark: .red)
            },
            as: .html
        ) {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                .color-jiDhg4{color:blue}
                @media (prefers-color-scheme: dark){
                  .color-dMYaj4{color:red}
                }
                </style>
              </head>
              <body>
                <div class="color-jiDhg4 color-dMYaj4">Hello</div>
              </body>
            </html>
            """
        }
    }
}
```

*The snapshot test shows our div element is rendering perfectly with both light- and dark-mode colors! Incredible.*

### The results

Here's what happened when I ran the tests after implementing dark mode:

- **swift-html-types**: ✅ All 840 tests pass unchanged (0.1 sec)
- **swift-css-types**: ✅ All 1,200+ tests pass unchanged (0.1 sec)
- **pointfree-html**: ✅ All 500+ tests pass unchanged (0.1 sec)
- **swift-html-css-pointfree**: ✅ All 300+ tests pass unchanged (0.8 sec)
- **swift-html**: ✅ All existing tests pass + 12 new tests (0.2 sec)

Only the package that actually owns the dark mode feature needed test changes. Over 2,800 tests across four packages continued passing without modification. 

If you've ever added a cross-cutting feature to a monolithic codebase, you know how remarkable this is. Usually you're updating tests for days, trying to understand why seemingly unrelated tests are failing.

## A surprise benefit: parallel testing

Here's something I didn't plan for but now can't live without: our CI pipeline runs all package tests in parallel. While `swift-html-types` runs its 840 tests, `swift-css-types` simultaneously runs its 1,200+ tests on a different core.

The entire suite of nearly 3,000 tests completes in about the same time as the slowest individual package. In a monolithic architecture, these would run sequentially. 

Even better—when you change code in `swift-css-types`, the HTML type tests don't run at all. They can't be affected by CSS changes, so why waste the time?

## Organizing for the long haul

Here's a simple practice that pays dividends: your test targets depend solely on their corresponding target:

```swift
// Package.swift
let package = Package(
    name: "swift-html-types",
    targets: [
        .target(name: "HTMLAttributeTypes"),
+       .testTarget(
+           name: "HTMLAttributeTypes Tests",
+           dependencies: ["HTMLAttributeTypes"]
+       ),
    ]
)
```

When your tests rely solely on the corresponding package, the compiler ensures the tests are focussed on that target.

I also advise to mirror your source structure in your tests:

```
swift-html-types/
├── Sources/
│   ├── HTMLAttributeTypes/
│   │   ├── Global/
│   │   │   ├── Autocapitalize.swift
│   │   │   ├── Autofocus.swift
│   │   │   └── ... (other global attributes)
│   │   ├── Internal/
│   │   │   ├── BooleanAttribute.swift
│   │   │   └── StringAttribute.swift
│   │   ├── Abbr.swift
│   │   ├── Accept.swift
│   │   └── ... (other attribute files)
│   └── HTMLElementTypes/
│       └── (similar structure)
└── Tests/
    ├── HTMLAttributeTypes Tests/
    │   ├── Global Tests/
    │   │   ├── Autocapitalize Tests.swift
    │   │   ├── Autofocus Tests.swift
    │   │   └── ... (other global tests)
    │   ├── Internal Tests/
    │   │   ├── BooleanAttribute Tests.swift
    │   │   └── StringAttribute Tests.swift
    │   ├── Abbr Tests.swift
    │   ├── Accept Tests.swift
    │   └── ... (other attribute tests)
    └── HTMLElementTypes Tests/
        └── (similar structure)
```

When every source file has a corresponding test file in the same relative location, everyone knows where to find things. New contributors can navigate the test suite immediately. And when you move code between modules, you move its tests to the same relative spot.

> TIP: I append " Tests" to test file names because it makes them easier to find with `cmd+shift+o` in Xcode.

## Moving code between modules

One more thing I've learned: when your tests follow the "test what you own" principle, extracting modules becomes mechanical:

1. Find tests that only use a specific subset of functionality
2. Move those tests to the new module's test suite  
3. Run everything—it should all still pass
4. Delete the tests from the original location

The tests usually move without any modifications because they were already testing just that module's functionality. The architecture guides the refactoring.

## What this means in practice

**Speed matters more than you think**. When tests run in milliseconds, you run them constantly. When they take minutes, you avoid them. Fast tests change how you work.

**Precision saves time**. Knowing exactly which package and which target contains a failure cuts debugging time dramatically.

**Boundaries guide design**. When you can't test across module boundaries, you're forced to design focussed tests. 

**Teams can actually work in parallel**. Different people can own different packages without stepping on each other. The test suites define clear ownership boundaries.

## Looking back

The dark mode example really drove it home for me. A feature that conceptually touches every layer of the system required changes in exactly one package. The 2,800+ tests in other packages kept passing, confirming that I hadn't broken anything.

But what surprised me most was how the architecture changed the development experience. Instead of carefully planning where each piece of code should go, I found myself discovering the natural home for each feature. Dark mode belonged in `swift-html` because that's where developer conveniences live. The decision wasn't a debate—it was obvious from the structure.

This is what good architecture does. It doesn't just organize code; it guides you toward the right decisions. When adding features feels like discovering rather than deciding, when each package has such a clear purpose that you know exactly where code belongs—that's when you know you've built something that will last.

---

*Next in this series: Documenting our modular HTML package ecosystem—because great architecture deserves great documentation.*




