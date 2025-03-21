# A journey building HTML documents in Swift

## Introduction

As a lawyer, I've written countless legal documents. But as my coding skills grew, I became increasingly frustrated that I couldn't easily apply these skills to my daily legal work. I tried automating tasks directly in Microsoft Word, and did produce some results, but they always felt like hacks. I often found myself repeatedly solving the same problems without the abstractions needed to address them once and reuse the solutions effectively. 

Today I want to share my ongoing journey building HTML documents in Swift and describe where I am today.

> Note: One of my earliest memories as a corporate lawyer was being criticized for not correctly formatting bullet lists according to the firm's style guide. Trivial issues—like forgetting semicolons after bullet points or incorrectly using "; and" on the penultimate item—were frustrating, especially since these formatting rules could be elegantly solved in code. I wanted to focus on the legal aspects I enjoyed rather than tedious formatting details.
>
> For instance:
> 1. This is list item 1;
> 2. This is list item 2; and
> 3. This is list item 3.

Swift doesn't have built-in support for generating HTML. However, nothing stops you from creating a very simple webpage with a greeting message using basic string interpolation. It might look like this in Swift:

```swift
let name = "Alice"
let htmlString = "<!DOCTYPE html>" +
"<html>" +
"  <boby>" +
"    <h1>Welcome, \(name)!</h1>" +
"    <p>We're glad you're here.</p>" +
"  </body>" +
"</html>"
```

This certainly produces the desired HTML, but it’s very easy to make a mistake. In fact, did you spot that I initially had a typo (‘boby’ instead of ‘body’)? And what if you forget a quote or a closing `</body>` tag? The compiler won’t warn you; you’ll only find out at runtime or when the browser fails to render correctly. Furthermore, the HTML structure is embedded in a string, so you don’t get any code completion or assistance from Swift regarding HTML tags or attributes. Finally, the code becomes quite difficult to read with all the quotes and plus signs cluttering things up.

Surely we can do better.

Early libraries, like John Sundell’s Plot, provided tools to generate HTML with a more declarative syntax, embedding HTML construction directly into Swift’s type system. With this approach, HTML elements become values in Swift, and the compiler can catch mistakes early.

## Plot

Plot was an enormous improvement over VBA—allowing me to programmatically generate and reuse HTML— but it still wasn't perfect. In Plot, it was possible but often difficult to express logic because everything had to rigorously adhere to a strict functional programming style. The syntax could be elegant, but working with sequences/collections and conditions had a steep learning curve, producing code that—while provably correct—wasn't always the most readable or maintainable. 


> Note: Here's how I would solve my formatting issue using plot.
> ```swift
> import Plot
>
> func createList() -> Node<HTML.BodyContext> {
>     .ol(
>         .forEach(
>             (1...3).map { number in
>                 "\(number). This is list item \(number)"
>             }
>             .appendingSeparators(atEnd: "."),
>             { itemText in
>                 .li(
>                     .text(itemText)
>                 )
>             }
>         )
>     )
> }
> ```

I had come a long way from VBA, but I couldn't imagine how much better things were yet to become.

## 'Discovering' Point-Free HTML

As a Point-Free subscriber since their early days, I had been aware of their `swift-html` library, although I initially preferred Plot’s syntax and didn't explore `swift-html` much. However, as I was interested in writing my own website in Swift, I kept an eye on their open source github repository for their website, which was also written in Swift. Around July 2024 I noticed some developments around their new homepage that came with a new approach to HTML, code-named 'Styleguide V2'. 

I realized the Point-Free team was quietly exploring a new approach to HTML generation—one they hadn’t explicitly publicized. After experimenting with this new approach myself, I found their newer style incredibly pleasant and expressive. 

The core of pointfree-html is simple: you define your HTML structures similarly to how you create views in SwiftUI, implementing a declarative body property:

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

This generates a clean, properly formatted HTML document—ready to print or render!

> Note: Now, I can solve my formatting woes by simply writing this (using the upcoming [coenttb/swift-html](https://github.com/coenttb/swift-html)):
>
> ```swift
> var body: some HTML {
>   HTMLMarkdown {
>       (1...3).map { number in
>           "\(number). This is list item \(number)"
>       }
>       .appendingSeparators(atEnd: ".")
>   }
> }
> ```
> That is absolutely amazing to me that such formatting is now taken care of automatically.

## What's Coming Next?

In our next posts, I plan to discuss:

- **A Tour of PointFreeHTML**
- **Layering on swift-css**
- **Building on the pointfree-html foundation with `swift-html`**
- **Standing on the shoulders of giants: customization**

Follow my progress on here on [coenttb.com](coenttb.com) by [subscribing to my newsletter](https://coenttb.com/en/newsletter/subscribe/request). Or follow me on [GitHub](https://github.com/coenttb/pointfree-html), or on [x/twitter](https://x.com/coenttb)

## Conclusion

Of all the approaches I've explored for generating HTML using Swift, I prefer the new `pointfree-html` approach the most. Because it unifies the codebase, context-switching between different programming languages such as HTML, CSS, and JavaScript becomes unnecessary. I've always wondered why document creation couldn't be simplified into a single language where the compiler catches bugs early, and a robust type system ensures syntactically correct HTML that's easy to reuse and compose into other components.

I'm thankful to Brandon and Stephen for creating `pointfree-html`, as it unifies the entire document creation process into Swift, making it genuinely enjoyable to write.

Visit the open-source [GitHub repository](https://github.com/coenttb/pointfree-html), star the project, submit feedback, or even contribute directly—I’d love your input to make this tool even better.
