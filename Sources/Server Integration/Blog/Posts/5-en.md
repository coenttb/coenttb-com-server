# Modern Swift Library Architecture: Composition of Packages

## When multi-target isn't enough

In part one, we built `HTMLPackage` and explored how modular targets give us compiler-enforced boundaries and selective imports. But even well-structured targets have limits. What if `HTMLPrinter` and `CSS` evolve on different timelines? What if we want to use our HTML types with SwiftUI—without dragging in a full CSS system?

That’s when modularity at the **package level** becomes essential.

Once you hit the ceiling of what a single package can manage, you open the door to something more powerful: composability *of* packages, where each evolves independently and integrates cleanly on its own terms.

Let me show you what happens when your successful library starts growing further.

We're building our HTMLPackage and naturally, we need CSS support. So let's add a new target called "CSS" to HTMLPackage.

```swift
// swift-tools-version:6.0
import PackageDescription
let package = Package(
    name: "HTMLPackage",
    products: [
        .library(name: "HTMLLibrary", targets: ["HTMLElements", "HTMLAttributes", "HTMLPrinter", "CSS"])
    ],
    targets: [
        .target(name: "CSS"),
        // ...
    ]
)
```

> NOTE: We quickly find out that our CSS target also has naming issues, for example, Color is both a [CSS type](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value) and a [CSS property](https://developer.mozilla.org/en-US/docs/Web/CSS/color). We learned in part 1 that targets each have their own namespace, so we create targets for Property, Type, etc. 
> It's advisable to strive for relatively unique target names, as this is required by the Swift Package Manager. If you name a target "Property", and a consumer also has a target called "Property", then this will cause a build error. For our CSS targets, we will prefix with 'CSS', so Property becomes CSSProperty, or—more accurately—CSSPropertyTypes.

We also update our imaginary HTMLPrinter to use our new CSS tools: 

```swift
// swift-tools-version:6.0
import PackageDescription
let package = Package(
    name: "HTMLPackage",
    targets: [
        // ...
+       .target(
+           name: "CSS",
+           dependencies: ["CSSPropertyTypes", "CSSTypeTypes", etc...]
+       ),
+       .target(name: "CSSPropertyTypes"),
+       .target(name: "CSSTypeTypes"),
+       // other CSS targets...
+       .target(
+           name: "HTMLPrinter",
+           dependencies: ["HTMLElements", "HTMLAttributes", "CSS"]
+       ),
    ]
)
```

> NOTE: our "CSS" target composes together the targets it relies on, exposing them through `@\_exported import` of the underlying targets like CSSPropertyTypes and CSSTypeTypes. This allows consumers to use the re-exported types without importing submodules themselves

But now our package's purpose is muddied. It has both a domain model for HTML, a domain model for CSS, and an HTMLPrinter that works just with these domains. With a single package, every HTMLPrinter update forces consumers to potentially update their HTMLElements dependency too, even if they're not using any new HTMLPrinter features. 

If we could decouple the HTMLPrinter into its own Swift package, we could rapidly iterate on it without having to update the version number of the HTML & CSS types. That would be a huge win. Thinking about it, there's no actual need for the HTML and CSS domain models to be in the same Swift Package—they could each live in their own packages. As the HTML and CSS standards evolve at different rates, it would be great to continuously update our CSS package without having to increment the HTML package's version number. Your HTMLElements types might be stable and rarely change—after all, the HTML specification itself evolves slowly.

This raises an interesting question: if HTMLPrinter is in a separate package and doesn't know about our specific HTML and CSS types, how can it render them? The answer involves a bit of protocol-oriented magic. (Check out [A Tour of PointFreeHTML](/blog/3) for the details).

The benefits of separation become even clearer when you consider different use cases. Imagine a team building a documentation generator. They want your HTML types to structure their output, but they're using SwiftUI for styling instead of CSS. With everything in one package, they're forced to include CSS types they'll never use, creating unnecessary coupling and increasing their binary size for no benefit. Worse, they might choose to reimplement your Types rather than take on unwanted dependencies, leading to ecosystem fragmentation.

Or consider team ownership. Different teams might own different parts of the functionality. The HTML type modeling team shouldn't be blocked by the rendering team's release schedule, and vice versa. Different teams might want to iterate at different speeds, conduct different testing strategies, or even use different development practices.

Integration flexibility also becomes constrained. You might want to provide multiple integration strategies—perhaps one that uses HTMLPrinter, one for SwiftUI, and a third for WebAssembly. Each integration shouldn't force consumers to pull in the others, but in a single package, this becomes architecturally difficult.

These challenges point to a fundamental insight: **modularity isn't just about code organization within a package—it's about enabling independent evolution and flexible composition across packages**. Let's explore how breaking HTMLPackage into a carefully designed ecosystem of packages solves these problems and enables possibilities we haven't even imagined yet.

## More fundamentals: Products

Before we explore architecture, let’s revisit how products actually work.

A Swift package contains the products that consumers of the package can import. From a package consumer's perspective, a package is simply a collection of products—usually libraries—that you can depend on in your Swift Package and import into your Swift source code.

Here's how it works in practice. When you want to use HTMLPackage in your own project, you add it as a dependency and then specify which products you need:

```swift
// In a consumer's Package.swift
let package = Package(
    name: "MyWebApp",
    dependencies: [
        .package(url: "https://github.com/yourteam/HTMLPackage", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MyWebApp",
            dependencies: [
                // You import the product "HTMLLibrary", not the targets
                .product(name: "HTMLLibrary", package: "HTMLPackage")
            ]
        )
    ]
)
```

Then in your Swift code, you import the product:

```swift
// In MyWebApp/Sources/MyWebApp/WebPage.swift
import HTMLLibrary  // This gives you access to all the public APIs from HTMLElements, HTMLAttributes, and HTMLPrinter

let page = Div {
    Link(url: "/about")
}
```

> TIP: Package consumers don't directly interact with targets—these are internal organizational units. Targets are the building blocks of products and are used as the organizational unit *within* a package because they can depend on each other, creating internal structure that products then expose to consumers.
>
> So, while packages are organized by their products, each package itself is organized via their targets.

What targets are to a product, products are to a package.

> NOTE: The term *module* is used in two different contexts. In the context *between* packages, it means the products of a package that can be imported by a consumer, and in the context *within* a package, it means the package's targets (and products of other packages) that can be imported by the packages' targets. Modules are also called dependencies. For example, when declaring a target, you provide a name and an array of *target dependencies*. And you now know that these target dependencies can be either another target in the package or a product of another package that the package depends on.

## The anatomy of a multi-package ecosystem

Let me show you what the solution looks like in practice with the actual architecture I built for `coenttb/swift-html`. This isn't theoretical—it's a real system serving real users, and every architectural decision was driven by actual problems I encountered while building HTML tooling in Swift.

Instead of one package trying to be everything to everyone, I created a carefully designed ecosystem where each package has a focused purpose:

```swift
// Package 1: swift-html-types - HTML domain model in Swift
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

// Package 2: swift-css-types - CSS domain model in Swift
let package = Package(
    name: "swift-css-types",
    products: [
        .library(name: "CSSTypes", targets: ["CSSTypes"]),
    ],
    targets: [
        .target(
            name: "CSS",
            dependencies: ["CSSPropertyTypes", "CSSTypeTypes", etc...]
        ),
    ]
)

// Package 3: pointfree-html - Decoupled printer that prints Swift types conforming to the HTML protocol into actual HTML
let package = Package(
    name: "pointfree-html",
    products: [
        .library(name: "PointFreeHTML", targets: ["PointFreeHTML"]),
    ],
    targets: [
        .target(name: "PointFreeHTML")
    ]
)

// Package 4: swift-html-css-pointfree - Integrates HTML with CSS and provides conformance to the HTML protocol such that it can be printed using PointFreeHTML.
let package = Package(
    name: "swift-html-css-pointfree",
    products: [
        .library(name: "HTMLCSSPointFree", targets: ["HTMLCSSPointFree"]),
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-html-types", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-css-types", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/pointfree-html", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "HTMLCSSPointFree",
            dependencies: [
                .product(name: "HTMLTypes", package: "swift-html-types"),
                .product(name: "CSSTypes", package: "swift-css-types"),
                .product(name: "Html", package: "pointfree-html"),
            ]
        )
    ]
)

// Package 5: swift-html - High-level developer experience
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

Here's what makes this architecture so powerful:

**`swift-html-types`** provides the foundational domain model. It defines HTML elements and attributes using pure Swift value types. This package is deliberately minimal and stable—it should change rarely because HTML itself changes rarely.

**`swift-css-types`** models CSS properties, values, and declarations as Swift types. It's completely independent of HTML—you could use it for CSS-in-JS systems, style processors, or design token generators. This separation means CSS innovations don't require HTML updates, and vice versa.

**`pointfree-html`** is an existing library that prints Swift types to actual HTML. By building on existing tools rather than reinventing everything, we get battle-tested HTML generation for free. This demonstrates another key principle: good ecosystems compose with existing solutions.

**`swift-html-css-pointfree`** provides the integration layer. It depends on the type packages and the printer, through the `callAsFunction` pattern we explored in [A Tour of PointFreeHTML](/blog/3) and adds CSS method chaining that makes the DSL feel natural. This is where the "magic" happens—where separate domain models compose into a unified development experience.

**`swift-html`** builds on the integration with developer ergonomics and enhancements. It provides SwiftUI-like components (VStack, HStack), light/dark mode color support, and other conveniences. Because it sits at the top of the dependency graph, it can evolve rapidly without affecting the stable core types.

## The power of independent evolution

Now each package can realize capabilities that simply aren't possible within a single package boundary:

**Independent versioning**: `swift-html-types` can reach version 2.0 while `swift-css-types` stays at 1.5. Consumers mix and match versions as needed. The design systems team can upgrade their CSS types dependency without being forced to update HTML types they don't even use.

**Focused use cases**: A CSS processing tool depends only on `swift-css-types` without pulling in HTML functionality. A documentation generator uses just `swift-html-types` without any printing logic. Each consumer gets exactly what they need, nothing more.

**Clear ownership boundaries**: Different teams can own different packages with clear API contracts between them. The CSS team iterates on color systems and layout properties while the HTML team focuses on semantic markup and accessibility attributes. Coordination happens through well-defined APIs rather than informal agreements.

**Flexible integration strategies**: `swift-html-css-pointfree` provides one integration approach, but other packages can provide different strategies without conflicts. Want integration with [Elementary](https://github.com/sliemeobn/elementary), [Plot](https://github.com/JohnSundell/Plot), [HTMLKit](https://github.com/vapor-community/HTMLKit), or [Swim](https://github.com/robb/Swim)? Each can build their own integration package using the same foundational types.

**Semantic versioning that makes sense**: Breaking changes in the integration layer don't require major version bumps in the stable type definitions. When `swift-html` goes from 1.0 to 2.0 with new SwiftUI-style components, `swift-html-types` can stay at 1.0 because the underlying HTML elements haven't changed.

It takes quite a bit of upfront work. But for libraries intended to be building blocks for other libraries, this flexibility doesn't just outweigh the overhead—it enables possibilities that simply aren't achievable with monolithic designs.

## The composition principle: integration happens outside

Here's the crucial architectural insight that makes this whole approach work: **integration happens outside the core types**.

The HTML and CSS domain models remain pure and focused, while the integration layer ensures they work with our HTMLPrinter (PointFreeHTML). This follows the principle of composition over inheritance—rather than forcing HTML elements to know about CSS, we compose them together in a separate layer-for example a different Swift Package.

In the case of PointFreeHTML, I applied the dependency inversion principle to fully decouple it. Instead of having to know about the specific types that will be printed, it works with any type that conforms to the HTML protocol.  

This means you can:
- Use the HTML types with a different CSS system (maybe you prefer Tailwind-style utilities)
- Use the CSS types with a different HTML system (maybe you're building a React Native bridge)  
- Swap out the integration layer for different API styles (maybe you prefer a more functional approach)
- Build entirely different integrations without changing the core types (maybe you want SwiftUI-style modifiers)

The packages form a clear dependency graph: `swift-html` depends on `swift-html-css-pointfree`, which depends on `swift-html-types`, `swift-css-types`, and `pointfree-html`. There are no circular dependencies, and each package has a single, focused responsibility.

But here's what makes this particularly elegant: if someone wants to build a completely different HTML DSL—maybe one that generates React components instead of raw HTML—they can reuse `swift-html-types` and `swift-css-types` without taking on any of the PointFree-specific integration code. The domain models become truly reusable building blocks.

## Migrating from Single Package to Multi-Package: A Step-by-Step Guide

The transition from `HTMLPackage` to our ecosystem didn't happen overnight. Here's the practical approach I used:

**Phase 1: Extract the stable core**
- Start with `swift-html-types` - move the most stable, foundational types first
- Keep the original package working during transition

**Phase 2: Create integration packages**
- Build `swift-html-css-pointfree` to bridge the gap
- Gradually migrate consumers to the new structure
- Maintain backward compatibility in the original package

**Phase 3: Deprecate the monolith**
- Mark old package as deprecated
- Provide clear migration guides
- Eventually archive the original repository

## When NOT to split packages: avoiding the pitfalls

Before you start splitting every target into its own package, let me share some hard-won wisdom about when this approach backfires spectacularly.

**Premature optimization is real**: If you're building a small library that's unlikely to have diverse consumers, the overhead of multiple packages often isn't worth it. Start with multiple targets in a single package and split when you actually encounter the problems we've discussed. It wouldn't be worth it to create a separate `swift-html-element-types` and `swift-html-attribute-types`, these are so coupled by their nature that they should remain in one Swift Package. Whenever you find that you have a target that is used by multiple other targets, and which you'd like to also use in other Swift Packages, you can consider extracting it into a separate Swift Package, or include it into a separate 'Utils' Swift Package. 

**Version resolution hell**: Multiple packages mean multiple version constraints. If Package A needs `html-types 1.0` but Package B needs `html-types 2.0`, your consumers face impossible dependency resolution.

**Development overhead compounds**: More packages mean more repositories, more release processes, more CI configurations, more documentation sites. Make sure you have the tooling and processes to handle this complexity before you commit to it.

**Circular dependencies by accident**: It's surprisingly easy to create circular dependencies when splitting packages. Always draw out your dependency graph before you start coding.

**Over-abstraction paralysis**: Sometimes trying to make everything reusable leads to APIs that are too generic to be useful. Don't sacrifice usability for theoretical flexibility unless you have concrete use cases driving the design.

Here are the rules of thumb I follow now:

**Start simple**: Begin with a single package and multiple targets. Only split when it you have concrete evidence of the problems we've discussed. With time, you'll know when to split when you see it.

**Identify the stable core** of your domain and separate it from the **evolving periphery**. Put the core concepts that rarely change in foundational packages, and build the rapidly-evolving convenience APIs on top.

**Optimize for stability**: Put the most stable, foundational types in the lowest-level packages. Save the experimental, rapidly-evolving stuff for higher-level packages. 

**Watch your dependency graph**: If your diagram looks like a spider web, you've probably over-engineered things. Clean, linear dependency graphs are easier to understand and maintain.

## The future of composable Swift ecosystems

We're already seeing libraries that adopt this approach, including Apple's [swift-http-types](https://github.com/apple/swift-http-types), and as the ecosystem matures, I expect we'll see more libraries adopting these patterns. The most successful libraries will be those that serve as building blocks for other libraries, not just end applications.

We're also seeing this with libraries like PointFree's [swift-composable-architecture](https://github.com/pointfreeco/swift-composable-architecture), which builds on more general packages like [swift-dependencies](https://github.com/pointfreeco/swift-dependencies) and [swift-case-paths](https://github.com/pointfreeco/swift-case-paths). Each package serves a focused purpose but they compose together to create powerful capabilities.

The future belongs to **composable ecosystems** rather than monolithic frameworks. Users want the flexibility to pick and choose the pieces that make sense for their specific use case, and they want those pieces to work well together without forcing unwanted dependencies.

As library authors, our job is to create those well-designed pieces and the integration layers that make them feel like a unified whole while preserving maximum flexibility.

The key insight is to identify the **stable core** of your domain and separate it from the **evolving periphery**. Put the core concepts that rarely change in foundational packages, and build the rapidly-evolving convenience APIs on top.


## Modularity as a design philosophy

Building modular Swift package ecosystems isn't just about organizing code—it's about enabling possibilities you can't yet imagine. When you design foundational packages that are focused, stable, and composable, you create opportunities for innovation that extend far beyond your original vision.

The HTML ecosystem I've built demonstrates these principles in action: stable domain types that rarely change, focused integration layers that can evolve rapidly, and clear boundaries that prevent accidental coupling. The result is a system that serves diverse use cases while maintaining coherence and simplicity.

But the real payoff isn't technical—it's human. Modular architectures enable collaborative development, distribute maintenance burden, and create opportunities for specialized expertise. They allow different parts of your system to evolve at different rates and serve different constituencies without forcing coordination on every change.

As you design your own Swift package ecosystems, remember that the goal isn't to create the perfect API today. It's to create a foundation that can evolve gracefully as you learn more about your problem domain and as your users discover new ways to apply your tools.

The best libraries are those that surprise their creators with what becomes possible. A CSS processing library built on your types, a design token generator you never imagined, a mobile development workflow that bridges web and native—these emergent possibilities are exactly what thoughtful modularization enables.

## Key takeaways for building your own ecosystem

**Start with the stable core**: Identify the concepts in your domain that change slowly and build foundational packages around them. These become the bedrock that everything else builds on.

**Design for composition**: Make your packages play well with others by keeping interfaces clean and avoiding assumptions about how they'll be used. The most successful packages are those that work in contexts their creators never imagined.

**Embrace the dependency graph**: Think carefully about the relationships between your packages. Clean, linear dependency graphs are easier to understand, maintain, and evolve than complex webs of interdependence.

**Version conservatively**: Breaking changes in foundational packages cascade through entire ecosystems. Design APIs that can evolve without breaking backward compatibility, and when you must make breaking changes, coordinate carefully across your ecosystem.

**Optimize for the unexpected**: The most valuable packages are those that enable use cases their creators never anticipated. Design for flexibility and composability even when you're not sure exactly how it will be used.

Start simple, split thoughtfully, and always optimize for the flexibility to be wrong about what the future holds. Because in software, as in life, the most interesting developments are usually the ones you never saw coming.

---

*Next in this series: a deep dive into `swift-html-types`, exploring how to model the entire HTML specification as Swift types and why getting the foundation right matters for everything that follows.*
