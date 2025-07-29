# coenttb-com-server

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift 6.0">
  <img src="https://img.shields.io/badge/Platforms-macOS%20|%20Linux-lightgray.svg" alt="Platforms">
  <img src="https://img.shields.io/badge/License-AGPL%203.0-blue.svg" alt="License">
  <img src="https://img.shields.io/badge/Vapor-4-purple.svg" alt="Vapor 4">
</p>

<p align="center">
  <strong>The open-source Swift server powering coenttb.com</strong><br>
  Built entirely in Swift with type-safe HTML generation and inspired by Point-Free
</p>

## Overview

**coenttb-com-server** is the complete source code for [coenttb.com](https://coenttb.com), a production Swift website built in the style of [Point-Free](https://www.github.com/pointfreeco/pointfreeco) and powered by [Vapor](https://www.github.com/vapor/vapor) & [coenttb-web](https://www.github.com/coenttb/coenttb-web).

Read more about me in my [introductory post on coenttb.com](https://www.coenttb.com/blog/1-from-broke-to-building-in-public-open-sourcing-coenttb-com).

### ✨ Key Features

- 🚀 **100% Swift** - Frontend to backend, all Swift
- 🛡️ **Type-safe HTML & CSS** - Catch errors at compile time
- 🧩 **Hypermodular architecture** - Clean separation of concerns
- ⚡ **Server-side rendering** - Fast, SEO-friendly pages
- 🎨 **Point-Free inspired** - Functional, composable patterns

## Why Open Source?

### 🎯 Mission

Swift for web development is powerful but underexplored. By open-sourcing coenttb.com, I aim to:

1. **Demonstrate** - Show how to structure a production Swift website elegantly
2. **Inspire** - Encourage others to build web applications in Swift
3. **Collaborate** - Gather feedback to improve the Swift web ecosystem

This is a real production website serving real users - not just a demo. Learn from actual patterns used in production.

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



// Type-safe HTML generation
struct BlogPostView: HTML {
    let post: BlogPost
    
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
```

## Ecosystem

### 🏗️ The coenttb Stack

This server is built on a comprehensive Swift web development stack:

#### Core Libraries
- **[swift-html](https://github.com/coenttb/swift-html)** - Type-safe HTML & CSS DSL
- **[swift-css](https://github.com/coenttb/swift-css)** - Type-safe CSS generation
- **[swift-web](https://github.com/coenttb/swift-web)** - Web development fundamentals

#### Extended Functionality
- **[coenttb-html](https://github.com/coenttb/coenttb-html)** - HTML extensions, Markdown, Email, PDF
- **[coenttb-web](https://github.com/coenttb/coenttb-web)** - Advanced web utilities
- **[coenttb-server](https://github.com/coenttb/coenttb-server)** - Server development tools
- **[coenttb-vapor](https://github.com/coenttb/coenttb-vapor)** - Vapor & Fluent integration

#### Point-Free Foundations
- **[pointfree-html](https://github.com/coenttb/pointfree-html)** - HTML rendering engine
- **[pointfree-web](https://github.com/coenttb/pointfree-web)** - Web foundations
- **[pointfree-server](https://github.com/coenttb/pointfree-server)** - Server foundations

#### Additional Tools
- **[swift-languages](https://github.com/coenttb/swift-languages)** - Cross-platform translations

## Project Structure

```
coenttb-com-server/
├── Sources/
│   ├── Server/             # Main server executable
│   ├── App/                # Application configuration
│   ├── Models/             # Database models
│   ├── Views/              # HTML views
│   ├── Controllers/        # Route handlers
│   └── Middleware/         # Custom middleware
├── Tests/                  # Test suite
├── Public/                 # Static assets
└── Resources/              # Email templates, etc.
```

## Features Demonstrated

- 🔐 **Authentication** - Complete user system with email verification
- 📝 **Blog Engine** - Markdown-based blog with syntax highlighting
- 💳 **Payments** - Stripe integration for subscriptions
- 📧 **Email System** - Type-safe transactional emails
- 🌍 **Internationalization** - Multi-language support
- 🎨 **Dark Mode** - Automatic theme switching
- 📱 **Responsive Design** - Mobile-first approach
- 🚀 **Performance** - Optimized for speed

## Contributing

Contributions are welcome! This project serves as both a production website and a learning resource for the Swift web community.

### Ways to Contribute

1. **Report Issues** - Found a bug? Let me know!
2. **Suggest Features** - Ideas for improvements
3. **Submit PRs** - Bug fixes and enhancements
4. **Share Knowledge** - Blog about your experience

## Support

- 🐛 **[Issue Tracker](https://github.com/coenttb/coenttb-com-server/issues)** - Report bugs or request features
- 💬 **[Discussions](https://github.com/coenttb/coenttb-com-server/discussions)** - Ask questions and share ideas
- 📧 **[Newsletter](http://coenttb.com/en/newsletter/subscribe)** - Swift web development tips
- 🐦 **[X (Twitter)](http://x.com/coenttb)** - Follow for updates
- 💼 **[LinkedIn](https://www.linkedin.com/in/tenthijeboonkkamp)** - Connect professionally

## Acknowledgements

This project is heavily inspired by the excellent work at [Point-Free](https://www.pointfree.co) by Brandon Williams and Stephen Celis. Their approach to building web applications in Swift has been instrumental in shaping this project.

## License

### Source Code
This project's source code is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**. See [LICENSE](LICENSE) for details.

### Content
- **Paid content** on [coenttb.com](https://coenttb.com) - All rights reserved
- **Free content** (blog posts, docs) - [CC BY-NC-SA 4.0](CC%20BY-NC-SA%204.0%20LICENSE)

### Commercial Licensing

Need to use this codebase without AGPL-3.0 requirements? Commercial licenses are available for:
- Proprietary software development
- SaaS products
- Avoiding open-source obligations

Contact **info@coenttb.com** for commercial licensing.

---

<p align="center">
  Made with ❤️ by <a href="https://coenttb.com">coenttb</a><br>
  <em>Building the future of Swift on the server</em>
</p>
