# Modern Swift Library Architecture: Composition of Modules

In my next series, we take a tour of `swift-html-types`, `swift-css-types`, `swift-html-css-pointfree`, and - ultimately, `swift-html`, to understand how they work and how to use them to create type-safe, composable HTML using Swift - much like SwiftUI.

Before that though, I want to take a step back and go over the overarching architecture. For example, why are these all separate packages, and not just one package?  

## What is a module?

Most Swift developers are familiar with Swift packages, but the relationship between packages, products, targets, and modules can be confusing. Let's clarify: each Swift Package contains one Package.swift. The Package.swift is just a swift file, but must instantiate one instance of the Package type. The Package type is instantiated with one or more products (like libraries or executables), and each product exposes one or more targets. A target is simply a subfolder in the Sources directory that contains source code, like .swift files.

Lets take a look at a concrete example. We will make an imaginary HTMLPackage. We start by creating a normal folder called "HTMLPackage". In this folder, we create a Package.swift, with the following contents:

```swift
// swift-tools-version:6.0
import PackageDescription
let package = Package(
    name: "HTMLPackage",
    products: [
        .library(name: "HTMLLibrary", targets: ["HTMLTarget"]),
    ],
    targets: [
        .target(
            name: "HTMLTarget"
        )
    ]
)
```

> Note: Each Swift package must have at least a folder titled `Sources`. For the above example - our HTMLPackage - the `Sources` folder will contain one folder (a *subfolder*), titled "HTMLTarget". Each target must have at least one swift file in it. In our example, we'll call that file HTMLTarget.swift.
> `// swift-tools-version:6.0` declares the version of the swift-tools, and `import PackageDescription` imports the Package type and related types necessary for the Package.swift.

This is all it takes to create a Swift Package titled HTMLPackage, which contains a library called "HTMLLibrary", which exposes the "HTMLTarget" target.

### The Monolith target
Now, as you continue to write code in HTMLTarget.swift, the file becomes larger and larger. This creates several problems:

1. Poor readability: A single 2,000-line file is nearly impossible to navigate and understand at a glance.
1. Merge conflicts: Multiple developers working on the same large file inevitably leads to painful Git conflicts.
1. Slow compilation: Swift's compiler has to process the entire file even for small changes, increasing build times.
1. Coupling issues: Everything in the same file has access to everything else, making it harder to enforce clean boundaries.
1. Testing difficulties: It becomes challenging to test individual components in isolation when everything is jumbled together.

### The multi-file target
The next step is to create more files in the HTMLTarget. You could have one for the `div` type, one for the `a` type, and so on. This helps initially because related functionality can be grouped into logical files (Div.swift, A.swift, etc.). Each file has a focused purpose, making the codebase more maintainable.

Additionally, we get the following benefits from separating into different files:
1. Reduced conflicts: Multiple developers can work on different files simultaneously with fewer merge issues.
1. Faster compilation: Swift can compile files in parallel and only recompile changed files.

However, just separating into files doesn't scale well because code in different files in the Target can still access each other's internals freely. It then becomes unclear which files depend on which others, making the codebase harder to understand and maintain. And equally bad: Consumers must import the entire target even if they only need a small part of the functionality. Finally, separating into separate files only, you still can't test individual components in true isolation—they're all part of the same module.

### The multi-target library

Then you will separate into separate targets, possibly separate libraries even. This is where the real power of modularization becomes apparent.

Let's extend our HTMLPackage example to show multiple targets:

```swift
// swift-tools-version:6.0
import PackageDescription
let package = Package(
    name: "HTMLPackage",
    products: [
        .library(name: "HTMLElements", targets: ["HTMLElements"]),
        .library(name: "HTMLAttributes", targets: ["HTMLAttributes"]),
        .library(name: "HTMLBuilder", targets: ["HTMLBuilder"]),
    ],
    targets: [
        .target(name: "HTMLElements"),
        .target(name: "HTMLAttributes"),
        .target(
            name: "HTMLBuilder",
            dependencies: ["HTMLElements", "HTMLAttributes"]
        )
    ]
)
```

Now we have three separate modules, each with its own focused responsibility. The HTMLBuilder target depends on both HTMLElements and HTMLAttributes, creating an explicit dependency graph.

When another package—let's call it "Swift Package A"—depends on HTMLPackage, Swift Package A can selectively import only the products it needs:

```swift
// In Package A - only import what you need
import HTMLElements     // Just the HTML Element types
import HTMLAttributes      // Just the HTML Attribute types  
import HTMLBuilder   // The builder that combines both

// Or import multiple at once
import HTMLElements
import HTMLBuilder

// Now we can use public APIs from these modules
let divType = Div()
let element = HTMLBuilder.createElement(divType)
```

But here's the key insight: in Swift Package Manager, every target becomes a module at compile time. This means the compiler enforces module boundaries—you can only access public APIs of modules you've imported.

This boundary is incredibly valuable for several reasons:

1. **Clear API contracts**: Modules give us precise control over what's exposed and what remains internal, encouraging proper encapsulation.
1. **Selective dependencies**: Consumers can import only the functionality they need, reducing compile times and keeping dependencies minimal.
1. **Compile-time safety**: Dependencies become explicit and compiler-checked, catching integration issues early.
1. **Maintenance boundaries**: In a well-modularized codebase, implementation details don't leak across module boundaries, making refactoring safer.
1. **True testability**: Each module can be tested in complete isolation, leading to more focused and reliable tests.
1. **Parallel development**: Different teams can work on different modules independently, as long as they respect the public API contracts.

When we structure our packages thoughtfully, we can enforce separation of concerns at the language level, keep codebases maintainable, and make them significantly easier to test and evolve over time.


## Composition of Swift Package libraries

We showed why you benefit from using multiple targets for your code. But even the multi-target approach has its limitations, especially when developing libraries. While the multi-target library solves many problems, there are scenarios where separating functionality into entirely different Swift packages becomes necessary.

Consider our HTMLPackage example. What happens when:

1. Different release cycles: Your HTMLElements types are stable and rarely change, but HTMLBuilder gets frequent updates with new features. With a single package, every HTMLBuilder update forces consumers to potentially update their HTMLElements dependency too.
1. Cross-project reuse: Another team wants to use your HTMLAttributes types in their CSS processing library, but they don't want to pull in HTMLElements or HTMLBuilder. In a single package, they're forced to depend on functionality they don't need.
1. Dependency conflicts: HTMLBuilder might need a specific version of a parsing library, while HTMLElements needs a different version of the same library. Within a single package, you can't have conflicting dependency requirements.
1. Team ownership: Different teams might own different parts of the functionality. The type modeling team shouldn't be blocked by the builder team's release schedule, and vice versa.
1. Integration flexibility: You might want to provide multiple integration strategies—perhaps one that integrates with SwiftUI, another with server-side rendering, and a third with WebAssembly. Each integration shouldn't force consumers to pull in the others.

This is where a **multi-package ecosystem** becomes valuable. Instead of one HTMLPackage, we might have:

```swift
// Package 1: swift-html-types
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

// Package 2: swift-css-types  
let package = Package(
    name: "swift-css-types",
    products: [
        .library(name: "CSSTypes", targets: ["CSSTypes"]),
    ],
    targets: [
        .target(name: "CSSTypes")
    ]
)

// Package 3: swift-html-css-pointfree
let package = Package(
    name: "swift-html-css-pointfree",
    products: [
        .library(name: "HTMLCSSPointFree", targets: ["HTMLCSSPointFree"]),
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-html-types", from: "1.0.0"),
        .package(url: "https://github.com/coenttb/swift-css-types", from: "2.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-html", from: "0.4.0"),
    ],
    targets: [
        .target(
            name: "HTMLCSSPointFree",
            dependencies: [
                .product(name: "HTMLTypes", package: "swift-html-types"),
                .product(name: "CSSTypes", package: "swift-css-types"),
                .product(name: "Html", package: "swift-html"),
            ]
        )
    ]
)
```

Now each package can:

1. **Evolve independently**: swift-html-types can reach version 2.0 while swift-css-types stays at 1.5, and consumers can mix and match versions as needed.
1. **Serve focused use cases**: A CSS processing tool can depend only on swift-css-types without pulling in HTML functionality.
1. **Maintain clear ownership**: Different teams can own different packages, with clear API contracts between them.
1. **Enable flexible integration**: swift-html-css-pointfree provides one integration strategy, but other packages could provide different approaches ([Elementary](https://github.com/sliemeobn/elementary), [Plot](https://github.com/JohnSundell/Plot), [HTMLKit](https://github.com/vapor-community/HTMLKit), and [Swim](https://github.com/robb/Swim) integration, for example) without conflicts.
1. **Support semantic versioning**: Breaking changes in the integration layer don't require major version bumps in the stable type definitions.
1. **Legal and licensing considerations**: Different parts of your codebase might need different licenses. Your core domain types might be MIT licensed for maximum reusability, while your integration with a GPL-licensed library might need to be GPL itself. You can't have multiple licenses within a single package—each Swift package can only have one license.

The trade-off is increased complexity—more repositories to manage, more dependency resolution, and more potential for version conflicts. But for libraries intended to be building blocks for other libraries, this flexibility often outweighs the overhead.

This multi-package approach is exactly what we've implemented with the `swift-html` ecosystem, where each package serves a specific, focused purpose while building upon the others.




## Why Modularity Matters
### Cross-domain reuse (e.g. CSS without HTML)
### Compile-time guarantees
### Explicit dependencies
### Testing and iteration

## Example of such an architecture: `swift-html`
### swift-html-types: Modeling the DOM
### swift-css-types: CSS as value types
### swift-html-css-pointfree: Integration via callAsFunction
### swift-html: Developer ergonomics and enhancements

## Integration Strategy
### How the packages build on one another
### Why integration happens outside core types
### Composition over inheritance (and protocol magic)

## Looking Ahead
### What the next posts will cover
### Who this is for (library authors, SwiftUI fans, web tool builders)




