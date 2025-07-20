# Modern Swift Library Architecture 1: The Swift Package

> NOTE: 
> This is Part 1 in a series exploring modern swift library architecture.
>  
> [Click here for part 2](https://coenttb.com/blog/5).
> 
> While the ideas in this article are my own, I've used AI to draft it-hope you don't mind the em-dashes (-). 

## What are the best, modern practices for architecting your Swift package? 

Picture this: you start building what seems like a simple HTML library. Six months later, you're stuck maintaining a 3,000-line monolith that's impossible to test and painful to update. But what if your library stayed modular, testable, and easy to evolve, no matter how large it became?

Let's explore how modern Swift architectures let you achieve exactly that.

> INFO: This article explores breaking targets into independently importable modules within a package. In part two, we'll see how multiple packages can evolve independently yet integrate seamlessly, creating powerful ecosystems.

## Introduction

I recently faced exactly this problem while building `coenttb/swift-html`, a domain-accurate and type-safe approach to generating HTML and CSS. The project started as a fork of `pointfreeco/swift-html` but evolved into something much more modular and composable as I encountered the limitations of monolithic design.

What started as a simple HTML DSL became an exploration of how to architect Swift libraries for maximum modularity and reusability. Instead of building one monolithic package, I created an ecosystem of carefully designed packages that compose together: `swift-html-types` and `swift-css-types` provide standards-compliant Swift APIs, while `swift-html-css-pointfree` integrates these domain models with HTML-rendering capabilities. `coenttb/swift-html` layers on functionality that completes the developer experience at point of use.

And here's what I discovered: **the most important architectural decisions happen both *within* each package and *between* them**. To build an ecosystem of packages, you need to first be familiar with modularization and composition within a single package. And once you run into the limits of what you can do *within* a package, you discover a whole new world of composability *of* packages.

Let's experience this together. We'll start with the fundamental building blocks, then build a package from scratch, progressively adding complexity. Along the way, we'll run into real problems and discover the solutions that make modular architecture possible.

## The building blocks: packages and modules

> Quick Reference:
> - **Swift package** = folder with a Package.swift file
> - **Package** = the name of the type that must be instantiated in Package.swift
> - **Target** = folder of source code located under /Sources in the package
> - **Product** = what consumers of your package can actually import
> - **Library** = a product that makes a target's public APIs available to import
> - **Module** = anything you can `import`
>     - Products can be imported by other packages that depend on this package
>     - Targets can be imported by other targets within the same package

When you're organizing code within a Swift package, targets are your primary tool. Each target is a separate module with its own namespace and compilation boundaries. This means you can break your package's functionality into focused, testable pieces that can depend on each other in controlled ways.

Think of targets as the rooms in your house—each has a specific purpose, clear boundaries, and controlled access points. Just as you wouldn't put your kitchen sink in the bedroom, you wouldn't put HTML parsing logic in your CSS utilities target.

The key insight is that **targets within a package can import each other**. This creates a dependency graph inside your package where you can build layers of functionality. Your HTMLAttributes target might be imported by HTMLElements, which means HTMLElements is aware of HTMLAttributes, but not the other way around. This creates clear separation while enabling composition.

Products are simply how you expose one or more targets to the outside world, and which allows them to be built by Swift. 

But rather than getting lost in definitions, let's see how these concepts work in practice by building an HTML library from scratch. We'll start simple and discover why each level of complexity becomes necessary.

## Building our first package: HTMLPackage

Let's start by building the simplest possible HTML library and see what happens as it grows. We'll discover firsthand why the obvious approaches break down, and more importantly, how Swift Package Manager's building blocks give us tools to solve each problem as it emerges.

Let's make this concrete by creating an imaginary Swift package called HTMLPackage from scratch. We'll use this as our playground to explore different architectural approaches—and more importantly, to see where each approach breaks down and why we need to evolve to the next level.

First create a folder named "HTMLPackage", and add a new file called Package.swift.

```
HTMLPackage/
└── Package.swift
```

 The Package.swift file always instantiates a Package type, most commonly like this:
 
 ```swift
// swift-tools-version:6.0
import PackageDescription
let package = Package(
    name: "HTMLPackage"
)
```

You now have the bare minimum for a Swift package. Nice! 

However, this Swift package doesn't do anything yet. Let's add some functionality. First add a `Sources` folder to the Swift package. Then, add a folder in Sources, let's call it "HTMLTarget", and add a file called "HTMLSourceCode.swift".

```
HTMLPackage/
├── Package.swift
└── Sources/
    └── HTMLTarget/
        └── HTMLSourceCode.swift
```

Now if you're working in Xcode, you might be suprised that you're not yet able to build HTMLTarget; it doesn't appear in the list of available build targets. This is because the build system doesn't look at the file system to determine available build targets, but instead looks at the Package.swift file.

To enable building of HTMLTarget, we must add it as a target to our Package.swift:

```swift
// swift-tools-version:6.0
import PackageDescription
let package = Package(
    name: "HTMLPackage",
    targets: [
+       .target(name: "HTMLTarget")
    ]
)
```

But still, HTMLTarget will not show up in the available build targets. Our final step is to specify a new product, lets call it "HTMLLibrary", that exposes HTMLTarget.

Now we will see HTMLLibrary show up as an available build target. Select it. Press `cmd+b`, and it should compile correctly.

```swift
// swift-tools-version:6.0
import PackageDescription
let package = Package(
    name: "HTMLPackage",
    products: [
+       .library(name: "HTMLLibrary", targets: ["HTMLTarget"])
    ],
    targets: [
        .target(name: "HTMLTarget")
    ]
)
```

Perfect! We now have a complete Swift package that we can build. HTMLPackage contains a library product called "HTMLLibrary" that exposes the "HTMLTarget" target. Other packages can depend on HTMLPackage and `import HTMLLibrary` to use our code.

But here's the thing: this simple structure is just the beginning. The real architectural decisions—and the real payoffs—come when we start asking harder questions: Should everything live in one target? How do we organize code as complexity grows? When do we break things apart, and when do we keep them together?

Let's find out by building something real.

## Adding some HTML types

Now let's add some actual Swift code to see our package in action. In `HTMLSourceCode.swift`, we'll create simple HTML element types that represent the building blocks of our DSL:

```swift
// HTMLSourceCode.swift
+ public struct Div {
+     static var tag: String { "div" }
+     public init() {}
+ }

// Also in HTMLSourceCode.swift
+ public struct Link {
+     static var tag: String { "a" }
+     public let url: String
+     
+     public init(url: String) {
+         self.url = url
+     }
+ }

// Also in HTMLSourceCode.swift
+ public struct HTMLPrinter {
+     // The implementation is not relevant here, but see [A Tour of PointFreeHTML](/blog/3) for a deeper dive.
+ }
```

Great! This gives us basic `Div`, `Link`, and `HTMLPrinter` types for generating HTML. Other packages can now import our `HTMLLibrary` and use these types—our first step toward a type-safe HTML DSL.

## The monolith approach: when simplicity becomes complexity

So we start adding more HTML elements to `HTMLSourceCode.swift`. First `Button`, then `Form`, then `Input`, `Table`, `Image`... and before we know it, we have a single file with over a hundred different HTML element types. That's easily 2,000+ lines of code in one file-this single file is going to become massive!

**You've created a monolith, and monoliths have predictable problems:**

- **Poor readability**: A single 2,000-line file is nearly impossible to navigate and understand at a glance. You spend more time scrolling than coding. When a new team member joins, they take one look at this file and immediately feel overwhelmed.
- **Forced coupling**: Everything in the same file has access to everything else, making it harder to enforce clean boundaries. Internal helper functions meant for `Button` can accidentally be used by `Table`, creating invisible dependencies that only surface when someone tries to refactor. Users who only want HTML element types are forced to import CSS utilities, server rendering logic, and everything else
- **Slow iteration**: Every change requires understanding and potentially affecting thousands of lines of code. Swift's compiler has to process the entire file even for small changes, increasing build times. Change one line in `Div`, wait for 2,000 lines to recompile. This feedback loop gets slower and slower as the file grows.
- **Testing nightmares**: It becomes impossible to test in isolation. 
- **Contribution barriers**: New contributors can't understand where to start or how changes might affect other parts of the system. Multiple developers working on the same large file inevitably leads to painful Git conflicts. And because everything's in one file, conflicts affect everyone. Simple changes become coordination nightmares.

But here's what makes this particularly insidious: these problems sneak up on you. At 50 lines, everything feels fine. At 200 lines, you start noticing compilation slowdowns but blame it on your machine. At 500 lines, you're spending real time scrolling to find things, but you tell yourself "I'll refactor this next sprint." By 2,000 lines, you're trapped in a monolith that's too big to refactor safely but too painful to live with.

Clearly, we need a better approach. But what's the right level of granularity?

## Multiple Files: Improved but Still Coupled

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

**Reduced conflicts**: Multiple developers can work on different files simultaneously with fewer merge issues. The days of coordinating who gets to touch the monolithic file are over.

**Faster compilation**: Swift can compile files in parallel and only recompile changed files. Modify `Button.swift`, and only that file needs to recompile.

**Easier navigation**: Finding the `Button` implementation is now a simple file search. Your IDE's file explorer becomes a useful organizational tool.

This is definitely better! Your team can finally work in parallel again. The compilation times improve. Life is good.

But as our HTML library grows, we start running into new problems that are subtler but ultimately more limiting.

The biggest issue is that code in different files within the same target can still access each other's internals freely. It becomes unclear which files depend on which others, making the codebase harder to understand and maintain as it grows. Your files on HTML attributes might start reaching into helpers defined in files on HTML Elements, creating invisible coupling that's only discovered when someone tries to move or delete code.

Even worse: consumers must import the entire target even if they only need a small part of the functionality. Someone who just wants to the HTML attribute types still has to pull in all the HTML element types too. Their binary size grows, their compile times increase, and they're forced to track security updates for code they don't even use.

And here's a particularly nasty problem that you might not encounter for months: naming conflicts. Since all files share the same namespace, you can't have two types with the same name—even if they represent completely different concepts. HTML has nine cases where elements and attributes share names (like `label`, `cite`, and `form`). In a single target, you'd be forced to use artificial naming like `LabelElement` and `LabelAttribute`, polluting your API with implementation details rather than clean domain concepts.

Finally, you still can't test individual components in true isolation—they're all part of the same module. Your HTML attribute tests might accidentally depend on behavior defined in HTML elements source files, making your test suite brittle and harder to understand.

So while multiple files help with organization, we need to think bigger about our architecture. We need true boundaries, not just file boundaries.

## Breaking into multiple targets: where real modularity begins

So what if we take this organization one step further? Instead of just separate files, what if we create separate *targets*?

> REMINDER: A target is a separate module with its own namespace and compilation boundaries. Each target can be imported by other targets within the same package, thereby exposing the public APIs of the target.

This unlocks something powerful: **true isolation with selective composition**. Your HTML attribute tests can import just `HTMLAttributes` without any HTML element logic. Your HTML element tests can import both `HTMLElements` with `HTMLAttributes` as needed. Most importantly, the compiler enforces these boundaries—no more accidental coupling between unrelated functionality.

Let's restructure our HTMLPackage to use multiple targets. Change Package.swift to:

```swift
// swift-tools-version:6.0
import PackageDescription
let package = Package(
    name: "HTMLPackage",
    products: [
        .library(name: "HTMLLibrary", targets: ["HTMLElements", "HTMLAttributes", "HTMLPrinter"])
    ],
    targets: [
+       .target(name: "HTMLAttributes"),
+       .target(
+           name: "HTMLElements",
+           dependencies: ["HTMLAttributes"]
+       ),
+       .target(
+           name: "HTMLPrinter",
+           dependencies: ["HTMLElements", "HTMLAttributes"]
+       )
    ]
)
```

And change our folder structure to:

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

Notice something fascinating? We can now have multiple files named `Label.swift`—one in HTMLElements for the label element, and another in HTMLAttributes for the label attribute. No more artificial naming like `LabelElement` and `LabelAttribute`! Each module gets its own namespace, so conflicts simply disappear.

> TIP: With separate targets, consumers can use both types without confusion:
> 
> ```swift
> import HTMLElements
> import HTMLAttributes
> 
> let labelElement = HTMLElements.Label(text: "Username")
> let labelAttribute = HTMLAttributes.Label(for: "username-input")
> ```
> 
> Or import selectively to avoid the namespace prefix:
> 
> ```swift
> import HTMLElements  // Label refers to the element
> 
> let label = Label(text: "Username")  // Clean, unambiguous
> ```

We now have three separate modules, each with its own focused responsibility:
- **HTMLElements** contains our element types
- **HTMLAttributes** contains our attribute types  
- **HTMLPrinter** knows how to combine them into actual HTML output

When we structure our packages this way, we enforce separation of concerns at the language level. The compiler becomes our friend, helping us maintain clean boundaries and making our code significantly easier to test and evolve over time.

```swift:3:fail
// In HTMLElements/Div.swift
public struct Div {
    public let attributes: [HTMLAttribute]
    // ...
}
```

This will produce the following error: 

> Error: Cannot find type 'HTMLAttribute' in scope. You need to import the HTMLAttributes module to access HTMLAttribute types.

By adding `import HTMLAttributes`, we expose its public APIs to Div.swift, giving it access to the HTMLAttribute type.  

```swift:5:pass
// In HTMLElements/Div.swift
+ import HTMLAttributes

public struct Div {
    public let attributes: [HTMLAttribute]
    // ...
}
```

Now build our HTMLElement target, and it compiles successfully! 

But even this multi-target approach has its limits. As our system grows, we start hitting constraints that can only be solved by thinking beyond a single package...

## The path forward: from single-package to multi-package architecture

Through our exploration of HTMLPackage, we've seen how architectural decisions evolve as complexity grows:

1. **Single file monolith**: Simple to start, becomes unmaintainable
2. **Multiple files**: Better organization, but shared namespace and forced coupling  
3. **Multiple targets**: True module boundaries with selective imports and compiler-enforced encapsulation

Our multi-target approach gives us focused, reusable building blocks where each target can be imported selectively and tested in isolation. Package consumers only pull in what they need, dramatically reducing compile times and binary size.

But even this has limits. The core issue is **forced coupling at the package level**—when HTMLPrinter gets performance updates, consumers must update their HTMLElements dependency too, even if they're not using new features. Teams wanting only HTMLAttributes for CSS processing are forced to pull in rendering logic they don't need.

More fundamentally, what if we want to print HTML types from third-party libraries? Or provide multiple integration strategies—SwiftUI, WebAssembly, server-side rendering—without forcing consumers to pull in all of them?

These challenges point to a key insight: **modularity isn't just about code organization within a package—it's about enabling independent evolution and flexible composition across packages**. 

That's exactly what we'll explore in part two, where we'll see how `swift-html-types`, `swift-css-types`, `swift-html-css-pointfree`, and `swift-html` compose together to create a unified development experience while maintaining independent evolution paths.

## Key takeaways

Before we move to multi-package ecosystems, it's crucial to be familiar with composition within packages:

**Start with clear boundaries**: Even within a single target, organize your code with clear boundaries in mind. This makes it easier to extract modules later when complexity demands it.

**Use the compiler as your friend**: Module boundaries aren't just organizational—they're compiler-enforced contracts that prevent accidental coupling and make refactoring safer.

**Design for selective imports**: Think carefully about what functionality belongs together. If consumers consistently need only part of what you're offering, consider breaking it into separate targets.

**Optimize for the 80% case**: Don't over-modularize prematurely, but don't under-modularize out of fear. Most libraries benefit from 2-5 focused targets rather than 1 monolith or 20 micro-targets.

**Test boundaries early**: If you can't easily test a component in isolation, it probably has too many dependencies. Use this as a signal that you need better boundaries.

The techniques we've explored—moving from monoliths to multiple files to multiple targets—form the foundation for everything we'll build in part two. Understanding when and how to break code into focused modules within a package is essential before you can effectively compose multiple packages into cohesive ecosystems.

---

*Next time, we'll see how this foundation enables us to build truly independent packages that compose together seamlessly, each evolving at its own pace while contributing to a unified development experience.*

👉 [Click here for part 2](https://coenttb.com/blog/5).
