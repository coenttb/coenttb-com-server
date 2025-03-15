# HTML in Swift

## Introduction

As a lawyer, I've written countless legal documents. But as my coding skills grew, I became increasingly frustrated that I couldn't easily apply those programming skills to my daily legal work. Automating tasks in Microsoft Word produced some results, but they always felt like hacks. I often solved the same problems repeatedly without the abstractions needed to solve them just once and reuse them effectively.

> Note: One of my earliest memories as a corporate lawyer was being criticized for not correctly formatting bullet lists according to the firm's style. Trivial stuff like forgetting semicolons after bullet points or using "; and" on the penultimate item was frustrating—especially since these issues could be elegantly solved in code. I wanted to focus on the legal aspects I enjoyed rather than tedious formatting.
>
> Like this:
> ```
> 1. This is list item 1;
> 2. This is list item 2; and
> 3. This is list item 3.
> ```

I've wanted to share my ongoing journey towards solving this frustration and describe where I am today.

When Swift was first released, I quickly realized its expressiveness was perfect for my needs. While Swift doesn't have built-in support for generating HTML, early libraries like John Sundell's Plot provided tools to generate HTML—I even built a GDPR compliance app and tools for creating corporate legal documents—but the tools never felt quite "right." I needed something in Swift that allowed me to write expressive, correct HTML while effortlessly manipulating text. Back then, I couldn't imagine how much better things would eventually become.

While Plot was an enormous improvement over VBA—allowing me to programmatically generate and reuse HTML—it still wasn't perfect. It was often difficult to express logic because everything had to rigorously adhere to a strict functional programming style. Working with collections and conditions had a steep learning curve, producing code that—while provably correct—wasn't always the most readable or maintainable.

```swift
import Plot

func createList() -> Node<HTML.BodyContext> {
    .ol(
        .forEach(Array(1...3)) { number in
            .li(
                .text("\(number). This is list item \(number)")
            )
        }
    )
}
```

I had come a long way from VBA, but I knew this couldn't be the end-all solution.

## Discovering Point-Free HTML

I’ve been a Point-Free subscriber since their early days. Although aware of their swift-html library, initially I preferred Plot’s syntax. However, after digging through their open-source website, I realized the Point-Free team was quietly exploring a new, even better approach to HTML generation—one they hadn’t explicitly publicized.

After experimenting, I found their newer style incredibly pleasant and expressive. The core of pointfree-html is simple: you define your HTML structures similarly to how you create views in SwiftUI, implementing a declarative body property:

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
> That is absolutely amazing to me!

## Why I love pointfree-html

`pointfree-html` has fundamentally changed the way I approach writing HTML, especially for legal document automation. Here’s why I think you’ll appreciate it too:

### 1. Type-Safe and Declarative Syntax

With `pointfree-html`, you're protected against common HTML errors thanks to Swift’s type-safe system. Its declarative style, familiar to anyone who’s worked with SwiftUI, clearly represents your intended HTML structure. You don't just get readability—you get peace of mind knowing your documents will render correctly.

```swift
div {
    h1 { "Contract Summary" }
    p { "This contract outlines the terms..." }
}
```

### 2. Easy, eeusable components

You can encapsulate common clauses—like confidentiality agreements, governing law statements, or disclaimers—into reusable Swift components, ensuring consistency and reducing duplication:

```swift
struct ConfidentialityClause: HTML {
  var body: some HTML {
    div(class: "clause confidentiality") {
      h2 { "Confidentiality" }
      p {
        """
        The parties agree to maintain strict confidentiality regarding all shared information...
        """
      }
    }
  }
}
```
> Important: Actual legal document componants can be much more complex and leverage all of Swift's features.

### 3. Built for extensibility

`pointfree-html` already makes document generation easy, but this is just the beginning. Upcoming integrations will enhance your documents further:

- **Type-Safe CSS:** Confidently create consistent, professional styles directly in Swift with `swift-css`.
- **Enhanced Markdown Integration:** Simplify richer text formatting for professional legal documents.
- **Advanced Output Formats:** Easily generate PDFs, formatted emails, or responsive web documents directly from Swift code. 

## What's Coming Next?

I’m planning posts on:

- **Type-safe styling with `swift-css`**
- **Advanced Markdown support**
- **PDF and automated email generation**

Follow my progress on here on [coenttb.com](coenttb.com), on [GitHub](https://github.com/coenttb/pointfree-html), or [subscribe to my newsletter](https://coenttb.com/en/newsletter/subscribe/request)!

## Conclusion

`pointfree-html` is the foundation of how I automate legal document creation—replacing tedious manual formatting with intuitive, type-safe Swift code, that is a joy to write.

Ready to automate your workflows and build expressive, maintainable HTML in Swift? We will layer on the `pointfree-html` foundation to bring it to a whole new level, and show how we can use Swift to generate HTML for websites, emails, and business- and legal documents.

Visit the open-source [GitHub repository](https://github.com/coenttb/pointfree-html), star the project, submit feedback, or even contribute directly—I’d love your input to make this tool even better.

Until next time.
