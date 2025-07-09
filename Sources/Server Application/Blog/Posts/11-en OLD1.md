# Modern Swift Library Architecture using Swift Packages

What are the best, modern practices for architecting your Swift Package or an ecosystem of Swift Packages? I explore this topic through `coenttb/swift-html`, an evolution of Point-Free's widely known HTML domain specific language (DSL) restructured using modern Swift package architecture principles.

## Introduction

I recently released a brand new version of my `coenttb/swift-html` library that provides a domain-driven and type-safe approach to generating HTML and CSS. The tools are elegant, performant, and give you direct access to the underlying web technologies without unnecessary abstractions. And these tools were made possible by an ecosystem of three foundational libraries I just open-sourced: `swift-html-types` and `swift-css-types`, which provide standards-compliant and semantically accurate Swift APIs for HTML elements and CSS declarations, and `swift-html-css-pointfree`, which integrates this domain model with the HTML-printing capabilities of PointFreeHTML.

Now it's time to put this modular architecture to the test by exploring how these packages compose together to create a unified development experience. This is my exploration of modern Swift library architecture—the best practices for bringing complex, multi-package ecosystems into your Swift projects. We want to be able to have highly focused, reusable packages as the foundation of our libraries, but we also want the benefits of:

- **Independent evolution**: Core domain types can remain stable and rarely change, while integration layers and developer ergonomics can iterate rapidly as we discover better APIs and patterns.

- **Selective dependencies**: Package consumers should be free to import only the functionality they need, reducing compile times and binary size. Some projects might only need HTML types for parsing, others might want the full rendering pipeline, and most likely in real-world, complex applications we will have a mixture of both.

- **Cross-project reuse**: You want to be able to share domain models across different contexts—a CSS processing library shouldn't need to pull in HTML rendering logic, and a other HTML rendering engines don't want to have to import PointFreeHTML.

And if all of that wasn't complex enough, we further want to accomplish this with as few breaking changes as possible when packages evolve independently.

Oh, and one last thing that is important to us: we want each package to be independently testable too.

So, we have some interesting architectural challenges ahead of us. The trade-off is increased complexity—more repositories to manage, more careful dependency design, and more potential for version conflicts. But for libraries intended to be building blocks for other libraries, this flexibility creates a more sustainable and adaptable ecosystem.

To understand how we built this four-package ecosystem—and more importantly, how you can apply these patterns to your own projects—we need to start with the fundamental building blocks. When we talk about "importing functionality" and "selective dependencies," what exactly are we working with? The answer lies in understanding how Swift Package Manager organizes code.

## The building blocks: modules and packages

Swift Package Manager gives us a hierarchy of building blocks for organizing code: packages contain products that expose targets, products of the library type are modules that we actually `import` and use. Let's start with modules since they're what developers interact with most directly.

For the purposes of this article, a **module** is anything you can `import` in Swift code—whether it's a system library like `Foundation`, a target you've defined in your own package, or a product from another Swift package your package depends on.

Think about it: when you write `import Foundation` or `import YourCustomLibrary`, you're importing modules. When someone creates a Swift package, other developers can `import` the libraries from that package.

My `coenttb/swift-html` package is itself a module because it's a library meant to be used by others. Some may use it to create HTML for their websites, others may use it to generate business documents like invoices. These clients can `import` the public APIs of `coenttb/swift-html` for their own purposes.

But here's the crucial insight: in modern library architecture, we don't just create one big module. We strategically break functionality into multiple, focused modules that can be imported independently. Someone building a CSS processor might only need `import CSSTypes` without pulling in any HTML rendering logic. A server-side tool might want `import HTMLTypes` without the PointFreeHTML integration.

Swift Package Manager is our primary tool for creating these focused modules and orchestrating how they compose together. It gives us the building blocks—packages, targets, and products—to construct modular ecosystems where each piece has a single responsibility and clear boundaries.

This is where the real power emerges: by understanding how packages, targets, and products relate to modules, we can architect systems that evolve gracefully, compose flexibly, and scale sustainably. Let's dive into these building blocks to see how they work together.

## What is a Swift Package?

Most Swift developers know about Swift packages, but the relationship between packages, products, targets, and modules can be confusing. And since we're going to be building an ecosystem of multiple packages, it's crucial we understand these building blocks first.

Let's break it down with a quick reference guide:

> **Quick Reference:**
> - **Package** = folder with a Package.swift file
> - **Product** = an externally visible build artifact available to clients of a package
> - **Library** = a product that makes a target's public APIs available to import
> - **Target** = folder of source code located under /Sources in the package
> - **Module** = anything you can `import`
>     - Libraries can be imported by other packages that depend on this package
>     - Targets can be imported by other targets within the same package

The Package.swift file instantiates a Package type with products (such as libraries or executables) that are built from one or more targets. Libraries become modules that can be imported, while executables are standalone programs you can run.

### Building our first package: HTMLPackage

Let's make this concrete by creating an imaginary Swift Package called HTMLPackage from scratch. We'll use this as our playground to explore different architectural approaches.

We start simple—just a folder and a single file:

```
HTMLPackage/
└── Package.swift
```

The `Package.swift` file begins with the bare minimum:

```swift
// swift-tools-version:6.0
import PackageDescription
let package = Package(
    name: "HTMLPackage"
)
```

But this isn't enough yet. Every Swift package needs a `Sources` folder containing at least one target folder with Swift source files:

```
HTMLPackage/
├── Package.swift
└── Sources/
    └── HTMLTarget/
        └── HTMLTarget.swift
```

Now we can complete our Package.swift by defining products and targets:

```swift
// swift-tools-version:6.0
import PackageDescription
let package = Package(
    name: "HTMLPackage",
    products: [
        .library(name: "HTMLLibrary", targets: ["HTMLTarget"]),
    ],
    targets: [
        .target(name: "HTMLTarget")
    ]
)
```

Perfect! We now have a complete Swift Package. HTMLPackage contains a library product called "HTMLLibrary" that exposes the "HTMLTarget" target. Other packages can depend on HTMLPackage and `import HTMLLibrary` to use our code.

But as we'll see, this simple structure is just the beginning. The real architectural decisions come when we start asking: should everything live in one target? One package? How do we organize code as complexity grows?

Here's the Point-Free style rewrite:

## Adding some HTML types

Now let's add some actual Swift code to see our package in action. In `HTMLTarget.swift`, we'll create simple HTML element types that represent the building blocks of our DSL:

```swift
// HTMLTarget.swift
public struct Div {   
    public init() {}
}

// Also in HTMLTarget.swift
public struct Link {
    public let url: String
    
    public init(url: String) {
        self.url = url
    }
}
```

Great! This gives us basic `Div` and `Link` types for generating HTML. Other packages can now import our `HTMLLibrary` and use these types—our first step toward a type-safe HTML DSL.

But here's the thing: there are over a hundred different HTML elements. As we continue adding more types to `HTMLTarget.swift`—`Button`, `Form`, `Input`, `Table`, `Image`, and so on—this single file is going to become massive. And that's where some interesting architectural challenges start to emerge.

Here's the Point-Free style rewrite:

## The monolith approach

So we start adding more HTML elements to `HTMLTarget.swift`. First `Button`, then `Form`, then `Input`, `Table`, `Image`... and before we know it, we have a single file with over a hundred different HTML element types. That's easily 2,000+ lines of code in one file.

And this creates some serious problems:

- **Poor readability**: A single 2,000-line file is nearly impossible to navigate and understand at a glance
- **Coupling issues**: Everything in the same file has access to everything else, making it harder to enforce clean boundaries  
- **Slow compilation**: Swift's compiler has to process the entire file even for small changes, increasing build times
- **Testing difficulties**: It becomes challenging to test individual components in isolation when everything is jumbled together
- **Merge conflicts**: Multiple developers working on the same large file inevitably leads to painful Git conflicts

Clearly, we need a better approach.

## Breaking into multiple files

The obvious next step is to create separate files within our HTMLTarget. We could have `Div.swift`, `Link.swift`, `Button.swift`, and so on. Each file has a focused purpose, making the codebase much more maintainable.

Let's update our folder structure:

```
HTMLPackage/
├── Package.swift
└── Sources/
    └── HTMLTarget/
        ├── Div.swift
        ├── Link.swift
        ├── LabelElement.swift
        ├── LabelAttribute.swift
        └── Button.swift
```

And we immediately get some nice benefits:
- **Reduced conflicts**: Multiple developers can work on different files simultaneously with fewer merge issues
- **Faster compilation**: Swift can compile files in parallel and only recompile changed files

This is definitely better! But as our HTML library grows, we start running into new problems.

The biggest issue is that code in different files within the same target can still access each other's internals freely. It becomes unclear which files depend on which others, making the codebase harder to understand and maintain as it grows.

Even worse: consumers must import the entire target even if they only need a small part of the functionality. Someone who just wants to use `Div` types still has to pull in all the `Button`, `Form`, and `Table` logic too.

And here's a particularly nasty problem: naming conflicts. Since all files share the same namespace, you can't have two types with the same name—even if they represent completely different concepts. HTML has nine cases where elements and attributes share names (like `label`, `cite`, and `form`). In a single target, you'd be forced to use artificial naming like `LabelElement` and `LabelAttribute`, polluting your API with implementation details rather than clean domain concepts.

Finally, you still can't test individual components in true isolation—they're all part of the same module.

So while multiple files help with organization, we need to think bigger about our architecture.

## Breaking into multiple targets

So what if we take this organization one step further? Instead of just separate files, what if we create separate *targets*? This is where the real power of modularization first becomes apparent.

Let's completely restructure our HTMLPackage to use multiple targets:

```swift
// swift-tools-version:6.0
import PackageDescription
let package = Package(
    name: "HTMLPackage",
    products: [
        .library(name: "HTMLElements", targets: ["HTMLElements"]),
        .library(name: "HTMLAttributes", targets: ["HTMLAttributes"]),
        .library(name: "HTMLPrinter", targets: ["HTMLPrinter"]),
    ],
    targets: [
        .target(name: "HTMLElements"),
        .target(name: "HTMLAttributes"),
        .target(
            name: "HTMLPrinter",
            dependencies: ["HTMLElements", "HTMLAttributes"]
        )
    ]
)
```

And our folder structure becomes:

```
HTMLPackage/
├── Package.swift
└── Sources/
    ├── HTMLElements/
    │   ├── Div.swift
    │   ├── Label.swift
    │   └── Link.swift
    ├── HTMLAttributes/
    │   ├── Class.swift
    │   ├── Href.swift
    │   └── Label.swift
    └── HTMLPrinter/
        └── HTMLPrinter.swift
```

Notice something interesting? We can now have multiple files named `Label.swift`—one in HTMLElements for the label element, and another in HTMLAttributes for the label attribute. No more artificial naming like `LabelElement` and `LabelAttribute`!

We now have three separate modules, each with its own focused responsibility. HTMLElements contains our element types, HTMLAttributes contains our attribute types, and HTMLPrinter knows how to combine them into actual HTML output.

And here's where it gets really powerful. When another package depends on HTMLPackage, they can selectively import only what they need:

```swift
// In another package - cherry-pick your imports
import HTMLElements     // Just the HTML element types
import HTMLAttributes   // Just the HTML attribute types  
import HTMLPrinter      // The printer that combines both

// Now we can use the public APIs
let divType = Div()
let element = HTMLPrinter.createElement(divType)
```

But here's the key insight: Swift Package Manager enforces module boundaries at the compiler level. You can only access public APIs of modules you've imported. This seemingly simple constraint unlocks tremendous benefits:

- **Clear API contracts**: We get precise control over what's exposed and what remains internal, encouraging proper encapsulation
- **Selective dependencies**: Consumers import only the functionality they need, reducing compile times and keeping dependencies minimal
- **Compile-time safety**: Dependencies become explicit and compiler-checked, catching integration issues early
- **Maintenance boundaries**: Implementation details can't leak across module boundaries, making refactoring much safer
- **True testability**: Each module can be tested in complete isolation, leading to more focused and reliable tests
- **Parallel development**: Different teams can work on different modules independently, as long as they respect the public API contracts

When we structure our packages this way, we enforce separation of concerns at the language level. The compiler becomes our friend, helping us maintain clean boundaries and making our code significantly easier to test and evolve over time.

But even this multi-target approach has its limits. As our HTML ecosystem grows, we'll discover scenarios where we need to think even bigger...

## Composition of Swift Package libraries

We showed why you benefit from using multiple targets for your code. But even the multi-target approach has its limitations, especially when developing libraries. While the multi-target library solves many problems, there are scenarios where separating functionality into entirely different Swift packages becomes necessary.

Consider our HTMLPackage example. What happens when different parts of your system need to evolve at different rates? Your HTMLElements types might be stable and rarely change, but HTMLPrinter gets frequent updates with new features. With a single package, every HTMLPrinter update forces consumers to potentially update their HTMLElements dependency too—even if they're not using any new HTMLPrinter features.

This becomes more problematic when you consider **cross-project reuse**. Another team might want to use your HTMLAttributes types in their CSS processing library, but they don't want to pull in HTMLElements or HTMLPrinter. In a single package, they're forced to depend on functionality they don't need, increasing their binary size and creating unnecessary coupling.

Team ownership also becomes complex. Different teams might own different parts of the functionality. The type modeling team shouldn't be blocked by the builder team's release schedule, and vice versa. Different teams might want to iterate at different speeds, conduct different testing strategies, or even use different development practices.

Finally, integration flexibility becomes constrained. You might want to provide multiple integration strategies—perhaps one that integrates with SwiftUI, another with server-side rendering, and a third with WebAssembly. Each integration shouldn't force consumers to pull in the others, but in a single package, this becomes difficult to manage cleanly.

These challenges point to a fundamental insight: **modularity isn't just about code organization—it's about enabling independent evolution and flexible composition**. When we move to separate packages, we unlock:

- **Independent versioning**: Core types can remain stable while integrations evolve rapidly
- **Precise dependencies**: Consumers pull in only what they need, nothing more
- **Cross-project reuse**: Domain models can be shared across different contexts without bringing along unrelated functionality
- **Compile-time guarantees**: The module system enforces clean boundaries and prevents accidental coupling
- **Explicit dependency graphs**: It becomes impossible to create circular dependencies or unclear relationships between components

This is where a **multi-package ecosystem** becomes valuable. Instead of one HTMLPackage, we might have:

```swift
// Package 1: swift-html-types: provides the foundational domain model. It defines HTML elements, attributes, and document structure using pure Swift value types. This package is deliberately minimal and stable—it changes rarely because HTML itself changes rarely. A CSS processing library can depend on just this package to work with HTML attribute types without pulling in any rendering logic
let package = Package(
    name: "swift-html-types",
    products: [
        .library(name: "HTMLAttributeTypes", targets: ["HTMLAttributeTypes"]),
        .library(name: "HTMLElementTypes", targets: ["HTMLElementTypes"]),
    ],
    targets: [
        .target(name: "HTMLAttributeTypes"),
        .target(name: "HTMLElementTypes")
    ]
)

// Package 2: swift-css-types: models CSS properties, values, and declarations as Swift types. It's completely independent of HTML—you could use it for CSS-in-JS systems, style processors, or any other CSS tooling. This separation means CSS innovations don't require HTML updates, and vice versa.
let package = Package(
    name: "swift-css-types",
    products: [
        .library(name: "CSSTypes", targets: ["CSSTypes"]),
    ],
    targets: [
        .target(name: "CSSTypes")
    ]
)

// Package 3: pointfree-html: prints Swift types to actual HTML that can be rendered in a browser.
let package = Package(
    name: "pointfree-html",
    products: [
        .library(name: "PointFreeHTML", targets: ["PointFreeHTML"]),
    ],
    targets: [
        .target(name: "PointFreeHTML")
    ]
)

// Package 4: swift-html-css-pointfree: provides the integration layer. It depends on both type packages and 'pointfree-html', adding the familiar `callAsFunction` pattern and CSS method chaining that makes the DSL feel natural. This is where the "magic" happens—where separate domain models compose into a unified development experience.
let package = Package(
    name: "swift-html-css-pointfree",
    products: [
        .library(name: "HTMLCSSPointFree", targets: ["HTMLCSSPointFree"]),
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-html-types", from: "1.0.0"),
        .package(url: "https://github.com/coenttb/swift-css-types", from: "2.0.0"),
        .package(url: "https://github.com/coenttb/pointfree-html", from: "0.4.0"),
    ],
    targets: [
        .target(
            name: "HTMLCSSPointFree",
            dependencies: [
                .product(name: "HTMLTypes", package: "swift-html-types`"),
                .product(name: "CSSTypes", package: "swift-css-types"),
                .product(name: "Html", package: "swift-html"),
            ]
        )
    ]
)

// Package 5: swift-html: builds on this foundation with developer ergonomics and enhancements. It provides SwiftUI-like components (VStack, HStack), light/dark mode color support, and other conveniences. Because it sits at the top of the dependency graph, it can evolve rapidly without affecting the stable core types.  
let package = Package(
    name: "swift-html",
    products: [
        .library(name: "HTML", targets: ["HTML"]),
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-html-css-pointfree", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "HTML",
            dependencies: [
                .product(name: "HTMLCSSPointFree", package: "swift-html-css-pointfree"),
            ]
        )
    ]
)
```

Now each package can:

1. **Evolve independently**: `swift-html-types` can reach version 2.0 while `swift-css-types` stays at 1.5, and consumers can mix and match versions as needed.
1. **Serve focused use cases**: A CSS processing tool can depend only on `swift-css-types` without pulling in HTML functionality.
1. **Maintain clear ownership**: Different teams can own different packages, with clear API contracts between them.
1. **Enable flexible integration**: `swift-html-css-pointfree` provides one integration strategy, but other packages could provide different approaches without conflicts ([Elementary](https://github.com/sliemeobn/elementary), [Plot](https://github.com/JohnSundell/Plot), [HTMLKit](https://github.com/vapor-community/HTMLKit), and [Swim](https://github.com/robb/Swim) integration, for example).
1. **Support semantic versioning**: Breaking changes in the integration layer don't require major version bumps in the stable type definitions.
1. **Legal and licensing considerations**: Different parts of your codebase might need different licenses. Your core domain types might be MIT licensed for maximum reusability, while your integration with a GPL-licensed library might need to be GPL itself. You can't have multiple licenses within a single package—each Swift package can only have one license.

The trade-off is increased complexity—more repositories to manage, more dependency resolution, and more potential for version conflicts. But for libraries intended to be building blocks for other libraries, this flexibility often outweighs the overhead.

## How the packages compose

The key insight is that **integration happens outside the core types**. The HTML and CSS domain models remain pure and focused, while the integration layer provides the developer experience. This follows the principle of composition over inheritance—rather than forcing HTML elements to know about CSS, we compose them together in a separate layer.

This approach means you can:
- Use the HTML types with a different CSS system
- Use the CSS types with a different HTML system  
- Swap out the integration layer for different API styles
- Build entirely different integrations without changing the core types

The packages form a clear dependency graph: `swift-html` depends on `swift-html-css-pointfree`, which depends on `swift-html-types`, `swift-css-types`, and `pointfree-html`. There are no circular dependencies, and each package has a single, focused responsibility.

## Looking ahead

In the upcoming posts, we'll dive deep into each package:

1. **`swift-html-types`**: How we model HTML elements and attributes as Swift types, and why this foundation matters for everything that follows
2. **`swift-css-types`**: Building a complete CSS type system, from properties to selectors to media queries
3. **`swift-html-css-pointfree`**: The integration magic—how `callAsFunction` and method chaining create a SwiftUI-like HTML DSL
4. **`swift-html`**: Developer ergonomics, components, and the final experience

This series is for library authors who want to understand modular architecture, SwiftUI developers curious about similar patterns in other domains, and anyone building web tooling in Swift. We'll explore not just how these packages work, but why they're designed the way they are—and how you can apply similar principles to your own projects.

The goal isn't just to build another HTML library, but to demonstrate how thoughtful modularization can create flexible, composable systems that evolve gracefully over time. By the end, you'll have a complete picture of how separate packages can work together to create something more powerful than any single monolithic solution.


In my next series, we take a tour of `swift-html-types`, `swift-css-types`, `swift-html-css-pointfree`, and - ultimately, `swift-html`, to understand how they work and how to use them to create type-safe, composable HTML using Swift - much like SwiftUI.
