# coenttb-com-server

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift 6.0">
  <img src="https://img.shields.io/badge/Platforms-macOS%20|%20Linux-lightgray.svg" alt="Platforms">
  <img src="https://img.shields.io/badge/License-AGPL--3.0%20|%20Commercial-blue.svg" alt="License">
  <img src="https://img.shields.io/badge/Vapor-4-purple.svg" alt="Vapor 4">
</p>

<p align="center">
  <strong>The open-source Swift server powering coenttb.com</strong><br>
  Built entirely in Swift with type-safe HTML generation and inspired by Point-Free
</p>

## Overview

**coenttb-com-server** is the complete source code for [coenttb.com](https://coenttb.com), a production Swift website built in the style of [Point-Free](https://www.github.com/pointfreeco/pointfreeco) and powered by [Vapor](https://www.github.com/vapor/vapor) & [coenttb-web](https://www.github.com/coenttb/coenttb-web).

Read more about me in my [introductory post on coenttb.com](https://www.coenttb.com/blog/1-from-broke-to-building-in-public-open-sourcing-coenttb-com).

## Key Features

- Written entirely in Swift - frontend to backend
- Type-safe HTML & CSS - Catch errors at compile time
- Modular architecture - Clean separation of concerns
- Server-side rendering - SEO-friendly pages
- Point-Free inspired - Functional, composable patterns

## Why Open Source?

Swift for web development is a viable approach that lacks production examples. By open-sourcing coenttb.com, I aim to:

1. **Demonstrate** - Show how to structure a production Swift website
2. **Inspire** - Encourage others to build web applications in Swift
3. **Collaborate** - Gather feedback to improve the Swift web ecosystem

This is a production website serving real users. Learn from actual patterns used in production.

## Quick Start

### Prerequisites

- Swift 5.10+ (Full Swift 6 support)
- macOS 14+ or Linux
- PostgreSQL 14+
- Xcode 15+ (for macOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/coenttb/coenttb-com-server
   cd coenttb-com-server
   ```

2. **Configure environment**
   ```bash
   cp .env.example .env.development
   ```

3. **Setup PostgreSQL**
   ```bash
   # Example DATABASE_URL format:
   # postgres://username:password@localhost:5432/database_name
   
   # For local development:
   postgres://admin:@localhost:5432/coenttb-development
   ```

4. **Run the server**
   ```bash
   swift run Server
   # Or in Xcode: Select the 'Server' scheme and run
   ```

   Visit `http://localhost:8080` to see your site!

## Architecture

This project demonstrates a modern, type-safe web architecture:

```swift
// Type-safe routing
@Dependency(\.coenttb.website.router) var router
app.mount(router, use: Route.response)

let home = router.url(for: .home)
let blog = router.url(for: .blog(.index))
let blogPost = router.url(for: .blog(.post(1)))


// Type-safe HTML generation
extension Blog.Post {
    struct View: HTML {
        let post: Blog.Post
        
        var body: some HTML {
            article {
                h1 { post.title }
                    .fontSize(.rem(2.5))
                
                div { post.content }
                    .lineHeight(1.6)
            }
            .maxWidth(.px(800))
            .margin(.auto)
        }
    }
}
```

## Ecosystem

This server is built on a comprehensive Swift web development stack:

#### Core Libraries
- **[swift-html](https://github.com/coenttb/swift-html)** - Type-safe HTML & CSS DSL
    - **[swift-html-types](https://github.com/coenttb/swift-html)** - Domain accurate and type-safe HTML types
    - **[swift-css-types](https://github.com/coenttb/swift-css)** - Domain accurate and type-safe CSS types
- **[swift-web](https://github.com/coenttb/swift-web)** - Web development fundamentals

#### Extended Functionality
- **[coenttb-html](https://github.com/coenttb/coenttb-html)** - HTML extensions, Markdown, Email, PDF
- **[coenttb-web](https://github.com/coenttb/coenttb-web)** - Advanced web utilities
- **[coenttb-server](https://github.com/coenttb/coenttb-server)** - Cross-platform server development tools
- **[coenttb-server-vapor](https://github.com/coenttb/coenttb-server-vapor)** - Vapor & Fluent integration

#### Point-Free Foundations
- **[pointfree-html](https://github.com/coenttb/pointfree-html)** - HTML rendering engine

#### Additional Tools
- **[swift-translating](https://github.com/coenttb/swift-translating)** - Cross-platform translations

## Features Demonstrated

- Blog Engine - Markdown-based blog with syntax highlighting
- Email System - Type-safe transactional emails
- Internationalization - Multi-language support
- Dark Mode - Automatic theme switching
- Responsive Design - Mobile-first approach
- Performance - Optimized for speed

## Contributing

Contributions are welcome! This project serves as both a production website and a learning resource for the Swift web community.

### Ways to Contribute

1. **Report Issues** - Found a bug? Let me know!
2. **Suggest Features** - Ideas for improvements
3. **Submit PRs** - Bug fixes and enhancements
4. **Share Knowledge** - Blog about your experience

## Support

- Issue Tracker - [Report bugs or request features](https://github.com/coenttb/coenttb-com-server/issues)
- Discussions - [Ask questions and share ideas](https://github.com/coenttb/coenttb-com-server/discussions)
- Newsletter - [Swift web development updates](http://coenttb.com/en/newsletter/subscribe)
- X (Twitter) - [Follow for updates](http://x.com/coenttb)
- LinkedIn - [Connect professionally](https://www.linkedin.com/in/tenthijeboonkkamp)

## Acknowledgements

This project relies on and is inspired by the excellent work at [Point-Free](https://www.pointfree.co) by Brandon Williams and Stephen Celis.

## Related Packages

### Dependencies

- [boiler](https://github.com/coenttb/boiler): The Swift web framework for building type-safe servers and websites.
- [coenttb](https://github.com/coenttb/coenttb): Personal profile repository showcasing Swift ecosystem contributions.
- [coenttb-blog](https://github.com/coenttb/coenttb-blog): A Swift package for blog functionality with HTML generation.
- [coenttb-google-analytics](https://github.com/coenttb/coenttb-google-analytics): A Swift package for Google Analytics integration.
- [coenttb-hotjar](https://github.com/coenttb/coenttb-hotjar): A Swift package for Hotjar analytics integration.
- [coenttb-newsletter](https://github.com/coenttb/coenttb-newsletter): A Swift package for newsletter subscription and email management.
- [coenttb-postgres](https://github.com/coenttb/coenttb-postgres): A Swift package with PostgreSQL utilities for Vapor.
- [coenttb-syndication](https://github.com/coenttb/coenttb-syndication): A Swift package for RSS and Atom feed generation.
- [swift-favicon](https://github.com/coenttb/swift-favicon): A Swift package for type-safe favicons.
- [swift-html](https://github.com/coenttb/swift-html): The Swift library for domain-accurate and type-safe HTML & CSS.
- [swift-mailgun](https://github.com/coenttb/swift-mailgun): The Swift library for the Mailgun API.
- [swift-server-foundation](https://github.com/coenttb/swift-server-foundation): A Swift package with tools to simplify server development.
- [swift-server-foundation-vapor](https://github.com/coenttb/swift-server-foundation-vapor): A Swift package integrating swift-server-foundation with Vapor.
- [swift-svg](https://github.com/coenttb/swift-svg): A Swift package for type-safe SVG generation.
- [swift-translating](https://github.com/coenttb/swift-translating): A Swift package for inline translations.

### Third-Party Dependencies

- [pointfreeco/swift-dependencies](https://github.com/pointfreeco/swift-dependencies): A dependency management library for controlling dependencies in Swift.
- [pointfreeco/xctest-dynamic-overlay](https://github.com/pointfreeco/xctest-dynamic-overlay): Define XCTest assertion helpers directly in production code.
- [m-barthelemy/vapor-queues-fluent-driver](https://github.com/m-barthelemy/vapor-queues-fluent-driver): [Description needed for vapor-queues-fluent-driver]
- [vapor/vapor](https://github.com/vapor/vapor): A server-side Swift HTTP web framework.

## License

This project is available under **dual licensing**:

### Open Source License
**GNU Affero General Public License v3.0 (AGPL-3.0)**  
Free for open source projects. See [LICENSE](LICENSE.md) for details.

### Commercial License
For proprietary/commercial use without AGPL restrictions.  
Contact **info@coenttb.com** for licensing options.

### Content License
- **Paid content** on [coenttb.com](https://coenttb.com) - All rights reserved
- **Free content** (blog posts, docs) - [CC BY-NC-SA 4.0](CC%20BY-NC-SA%204.0%20LICENSE)

---

---

Made by [coenttb](https://coenttb.com)
