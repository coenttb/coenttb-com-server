# A tour of PointFreeHTML

> NOTE: 
> While the ideas in this article are my own, I've used AI to draft it-hope you don't mind the em-dashes (-). 

In my previous post, we discussed HTML generation in Swift and arrived at [html-pointfree](https://github.com/coenttb/pointfree-html). 

Let's find out what is actually going on behind those pretty APIs.

## At Point of use: Creating HTML components

Here's how you typically build custom HTML elements—or components—using `pointfree-html`. You define them as structs (or enums) conforming to the `HTML` protocol, just like Views in SwiftUI:

```swift
struct Example: HTML {
    let name: String
    
    var body: some HTML {
        div {
            h1 { "Hello, \(name)!" }
            p { "Welcome to pointfree-html." }
        }
    }
}
```

You can then easily use this component in an HTML document:
```swift
struct ExampleDocument: HTMLDocument {
    var head: some HTML {
        title { "My Page" }
    }
    
    var body: some HTML {
        Example(name: "Coen")
    }
}
```
And voilà—ExampleDocument is a fully-renderable HTML page, ready to display in a browser or print to paper.

## The HTML Protocol: Elegantly Recursive

At the heart of pointfree-html is the deceptively simple HTML protocol:
```swift
public protocol HTML {
    associatedtype Content: HTML
    @HTMLBuilder
    var body: Content { get }
    static func _render(_ html: Self, into printer: inout HTMLPrinter)
}
```

The intriguing part is that the Content itself must conform to HTML. But then... that Content will also have a Content associatedtype. And wouldn't that also have to conform to the `HTML` protocol? That's exactly right! This recursive definition might seem a little puzzling at first glance—but it hints at a deeper elegance beneath the surface.

> Note: The addition of @HTMLBuilder to the `var body` refers to a custom result builder that to construct the HTML.

### The Hidden Magic of \_render

Underneath this elegant recursion via `body` lies another, hidden requirement—a static method called \_render.

Normally you don't have to deal with \_render at all because `pointfree-html` includes a handy default implementation:
```swift
extension HTML {
    /// Default implementation delegates rendering to the component’s `body`
    public static func \_render(_ html: Self, into printer: inout HTMLPrinter) {
        Content.\_render(html.body, into: &printer)
    }
}
```
This default implementation cleverly delegates rendering back to the Content's render implementation. Conceptually, this pushes rendering to the edge-nodes of our HTML tree.

## Direct Rendering: The HTML Building Blocks

Delegation is great for custom components, but at some point, actual HTML needs to be generated. Fundamental HTML elements—like `<div>`, `<p>`, and `<span>`—bypass delegation via `body` altogether. They directly render themselves using \_render, writing HTML output straight into an internal helper called HTMLPrinter.

### So, What’s an HTMLPrinter?

The HTMLPrinter struct is at the heart of the rendering system. It’s an internal engine quietly assembling your HTML into its final byte representation. You rarely interact directly with it—but you can tweak its behavior via the environment, thanks to PointFree’s excellent swift-dependencies library:
```swift
.dependency(\.htmlPrinter.configuration, .pretty)
```
Or, if you prefer something more explicit:
```swift
withDependencies {
    $0.htmlPrinter.configuration = .pretty
} {
    // HTML rendered here will be neatly formatted
}
```

Setting the configuration to .pretty makes your HTML easy to read and debug—perfect for spotting issues quickly.

The rendered bytes are efficient too, letting you pass them directly to browsers without unnecessary conversions through intermediate strings.

## Elements: SwiftUI-like syntax for HTML

### The Tag Abstraction: HTMLTag and HTMLElement

At the heart of `pointfree-html`'s elegant API lies a clever abstraction: the separation of tag definitions from the actual HTML elements they create. This design decision enables the library's intuitive syntax while maintaining a clean internal architecture.

#### Why HTMLTag doesn't conform to HTML

If you look at the code for `div`, `p`, or any other tag, you'll notice something surprising: these tag variables don't directly conform to the `HTML` protocol. Instead, they're instances of `HTMLTag` (or specialized variants like `HTMLVoidTag` for self-closing elements):

```swift
public var div: HTMLTag { #function }
public var p: HTMLTag { #function }
public var br: HTMLVoidTag { #function }
```

This approach solves a critical design challenge: how do we provide both an empty version of a tag (`div()`) and a content-containing version (`div { ... }`) without code duplication? 

> INFO: The name of the swift var is synchronized with the return value via the #function macro; the `#function macro` returns the name of the function. 

#### The Tag-to-Element Transformation

`HTMLTag` acts as a factory that creates `HTMLElement` instances, which do conform to `HTML`. This happens through HTMLTag's `callAsFunction()` methods:

```swift
public struct HTMLTag: ExpressibleByStringLiteral {
    public let rawValue: String
    
    // For empty elements: div()
    public func callAsFunction() -> HTMLElement<HTMLEmpty> {
        tag(self.rawValue)
    }
    
    // For elements with content: div { ... }
    public func callAsFunction<T: HTML>(@HTMLBuilder _ content: () -> T) -> HTMLElement<T> {
        tag(self.rawValue, content)
    }
}
```

When you write `div { "Hello" }`, Swift interprets this as calling `div.callAsFunction { "Hello" }`, returning an `HTMLElement<HTMLText>` instance that now conforms to `HTML` and can be rendered.

#### The Element implementation

`HTMLElement` is where the actual HTML rendering happens. Let's look at how the `_render` method actually transforms our elements into bytes. 

When an `HTMLElement` renders itself, it follows a precise sequence of steps:

```swift
public static func _render(_ html: Self, into printer: inout HTMLPrinter) {
    // Special handling for pre elements to preserve formatting
    let isPreElement = html.tag == "pre"
    
    // Add newline and indentation for block elements
    if html.isBlock {
        printer.bytes.append(contentsOf: printer.configuration.newline.utf8)
        printer.bytes.append(contentsOf: printer.currentIndentation.utf8)
    }
    
    // Write opening tag and attributes...
    
    // Render content if present
    if let content = html.content {
        // Store current state
        let oldAttributes = printer.attributes
        let oldIndentation = printer.currentIndentation
        defer { /* Restore state afterward */ }
        
        // Clear attributes and increase indentation for nested content
        printer.attributes.removeAll()
        if html.isBlock && !isPreElement {
            printer.currentIndentation += printer.configuration.indentation
        }
        
        // Recursively render child content
        Content._render(content, into: &printer)
    }
    
    // Add closing tag unless it's a void element
    // ...
}
```

This method does several clever things:

First, it handles special cases like `<pre>` elements which need to preserve their internal formatting exactly as written.

For block-level elements (like `<div>` or `<p>`), it adds appropriate newlines and indentation to create readable HTML output. Inline elements (like `<span>` or `<a>`) are rendered without these extras to maintain natural text flow.

The element's opening tag and all its attributes are written directly as bytes to the printer's buffer – including proper escaping of special characters in attribute values to prevent HTML injection.

Then comes the recursive magic: if the element has content, the method:
1. Saves the current printer state (attributes and indentation)
2. Clears attributes (since they don't apply to child elements)
3. Increases indentation for better readability
4. Recursively calls `_render` on the child content
5. Restores the original printer state using Swift's powerful `defer` keyword

Finally, unless it's a self-closing (void) element like `<br>` or `<img>`, it adds the closing tag with appropriate indentation.

All of this happens without creating intermediate string representations. The HTML is built byte-by-byte directly into the printer's buffer, making the rendering process both memory-efficient and fast.

This approach to rendering is what allows `pointfree-html` to handle complex nested structures while maintaining clean, readable output and high performance.

## Attributes: simply methods

One of the most elegant aspects of `pointfree-html` is how it handles HTML attributes. 

### The Attribute extension pattern

In HTML, attributes like `class`, `id`, and `href` modify elements. In `pointfree-html`, all attributes are implemented through a single extension on the `HTML` protocol:

```swift
extension HTML {
    public func attribute(_ name: String, _ value: String? = "") -> _HTMLAttributes<Self> {
        _HTMLAttributes(content: self, attributes: value.map { [name: $0] } ?? [:])
    }
}
```

This approach enables a fluent, chainable API that feels natural in Swift:

```swift
a { "Visit our website" }
    .attribute("href", "https://example.com")
    .attribute("target", "_blank")
    .attribute("rel", "noopener")
```

> Spoiler: We will use the attributes method as the tool upon which to create a domain model for attributes in `coenttb/swift-html`, enabling all sort of conveniences:
> ```
>  // Convenience wrappers
>     public func href(_ value: String?) -> _HTMLAttributes<Self> { attribute("href", value) }
>     public func src(_ value: String?) -> _HTMLAttributes<Self> { attribute("src", value) }
>     public func alt(_ value: String?) -> _HTMLAttributes<Self> { attribute("alt", value) }
>   

### The `_HTMLAttributes` Wrapper

Behind the scenes, the `attribute` method wraps the original HTML element in a special `_HTMLAttributes` struct:

```swift
public struct _HTMLAttributes<Content: HTML>: HTML {
    let content: Content
    var attributes: OrderedDictionary<String, String>
    
    public func attribute(_ name: String, _ value: String? = "") -> _HTMLAttributes<Content> {
        var copy = self
        copy.attributes[name] = value
        return copy
    }
}
```

This wrapper contains both the original HTML content and a dictionary of attributes to apply. Each time you chain another attribute, it creates a modified copy with the new attribute added.

### Rendering with attributes

The magic happens in the `_render` method:

```swift
public static func _render(_ html: Self, into printer: inout HTMLPrinter) {
    let previousValue = printer.attributes
    defer { printer.attributes = previousValue }
    printer.attributes.merge(html.attributes, uniquingKeysWith: { $1 })
    Content._render(html.content, into: &printer)
}
```

This method:
1. Saves the current printer attributes
2. Merges in the new attributes (with newer values overriding older ones)
3. Renders the wrapped content, which will now have access to these attributes
4. Restores the previous attributes using Swift's `defer` keyword

When the element itself renders, it accesses `printer.attributes` to get all the attributes that should be applied.

> NOTE: `_HTMLAttributes` uses direct rendering rather than delegating through a `body` property. 

This pattern is common for wrapper types in `pointfree-html` that need to modify the rendering context rather than just compose HTML elements.

## Inline Styles: CSS in Swift

One of the most impressive features of `pointfree-html` is its handling of CSS styling. Rather than requiring you to write and maintain separate CSS files, the library offers a brilliant approach to styling directly within your Swift code.

### The `inlineStyle` Method

Much like attributes, styles are applied using an extension on the `HTML` protocol:

```swift
extension HTML {
    public func inlineStyle(
        _ property: String,
        _ value: String?,
        media mediaQuery: MediaQuery? = nil,
        pre: String? = nil,
        pseudo: Pseudo? = nil
    ) -> HTMLInlineStyle<Self> {
        HTMLInlineStyle(content: self, property: property, value: value, mediaQuery: mediaQuery, pre: pre, pseudo: pseudo)
    }
}
```

This enables a beautifully expressive API for styling:

```swift
div {
    "Hello, World!"
}
.inlineStyle("color", "blue")
.inlineStyle("font-size", "1.5rem")
.inlineStyle("font-weight", "bold", pseudo: .hover)
```

> Spoiler: We will use the inlineStyles method as the tool upon which to create a domain model for styles in `coenttb/swift-html`, using `coenttb/swift-css`.

### How Styles Are Managed

Behind the scenes, `HTMLInlineStyle` doesn't actually create inline styles using the HTML `style` attribute. Instead, it takes a much more sophisticated approach:

1. Each style (property-value pair) is tracked
2. A unique CSS class name is generated for each style
3. The class names are added to the element's `class` attribute
4. The style definitions are collected in a stylesheet

This is considerably more efficient than using inline styles, as it automatically deduplicates identical styles across your document.

### Advanced Features

The styling system goes far beyond basic property-value pairs:

```swift
// Pseudo-classes and pseudo-elements
button { "Hover me" }
    .inlineStyle("background-color", "blue")
    .inlineStyle("background-color", "red", pseudo: .hover)

// Media queries
div { "Responsive content" }
    .inlineStyle("font-size", "16px")
    .inlineStyle("font-size", "14px", media: .dark)
    .inlineStyle("font-size", "18px", media: MediaQuery(rawValue: "(min-width: 768px)"))
```

The `Pseudo` and `MediaQuery` types provide type-safe access to common CSS features, while still allowing custom values when needed.

### The Rendering Pipeline

The `_render` method for `HTMLInlineStyle` showcases the elegant approach:

```swift
public static func _render(_ html: HTMLInlineStyle<Content>, into printer: inout HTMLPrinter) {
    let previousClass = printer.attributes["class"]
    defer {
        Content._render(html.content, into: &printer)
        printer.attributes["class"] = previousClass
    }
    
    for style in html.styles {
        // Generate a unique class name for this style
        let className = html.classNameGenerator.generate(style)
        
        // Create a CSS selector with any pseudo-elements/classes
        let selector = "\(style.preSelector.map { "\($0) " } ?? "").\(className)\(style.pseudo?.rawValue ?? "")"
        
        // Add the style to the printer's stylesheet
        if printer.styles[style.media, default: [:]][selector] == nil {
            printer.styles[style.media, default: [:]][selector] = "\(style.property):\(style.value)"
        }
        
        // Add the class name to the element
        printer.attributes["class", default: ""].append(
            printer.attributes.keys.contains("class") ? " \(className)" : className
        )
    }
}
```

The `HTMLPrinter` maintains both the element's attributes and a collection of styles that will be rendered as a stylesheet in the document head.

### Class Name Generation

To ensure efficiency, the library uses a dependency-injected `ClassNameGenerator` that creates short, unique class names. In debug builds, these names are more descriptive (e.g., `color-0`), while in release builds they're minified (e.g., `c0`).

This approach leverages Swift's dependency injection system to make the generation process both testable and efficient.

### Performance Considerations

The styling system includes several optimizations:

1. A hash function to detect duplicate styles
2. Ordered collections to maintain consistent output
3. Thread-safe style collection using `LockIsolated`
4. Conditional compilation for debug/release class name strategies

These details ensure that even complex documents with many styles render efficiently.

### The Result

When your HTML document renders, the `HTMLPrinter` collects all these styles and generates a proper CSS stylesheet in the document's `<head>`. The result is clean, efficient HTML with proper separation of content and presentation, all while maintaining the convenience of co-locating your styles with your elements.

This styling system is one of the most compelling examples of how `pointfree-html` transforms traditionally cumbersome web development tasks into elegant, type-safe Swift code.

## Wrap-Up

With pointfree-html, generating HTML becomes declarative, predictable, and type-safe. This approach fosters clarity, encourages composability, and transforms HTML generation from a tedious task into an enjoyable experience. It provides a foundation to build even more expressive HTML code upon. Instead of stringly 

In the next post, we’ll explore these concepts even further, diving into how you can leverage this elegant pattern to build sophisticated, maintainable UIs. Stay tuned!
