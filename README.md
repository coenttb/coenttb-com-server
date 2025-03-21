# coenttb.com - Swift Vapor website in the style of PointFree

`coenttb-com-server` is the source code for [coenttb.com](https://coenttb.com), written entirely in Swift in the style of [PointFree](https://www.github.com/pointfreeco/pointfreeco) and powered by [Vapor](https://www.github.com/vapor/vapor) & [coenttb-web](https://www.github.com/coenttb/coenttb-web).

Read more about me in my [introductory post on coenttb.com](https://www.coenttb.com/blog/1-from-broke-to-building-in-public-open-sourcing-coenttb-com).

### Key Features
- **Built entirely in Swift** 
- **Fully type safe**
- **Hypermodular**

## Why open source?

Building in Swift for the web is worth it, but the ecosystem is not yet mature. By open-sourcing this project, I hope to:
1. Show you how to structure a Swift website *elegantly*.
2. Inspire you to try it for yourself.
2. Get feedback to make the ecosystem even better.  

## Getting started

1. Clone the repo.
2. Copy the `.env.example` file and rename it `.env.development`.
3. Start a [postgres server](https://www.postgresql.org/download/). Adjust the `DATABASE_URL` variable in your `.env.development` to whatever you name your server. If your server is called `example-com-server-development`, on `port 5432`, on `localhost`, with a database user named `admin` then the correct syntax is `postgres://admin:@localhost:5432/example-com-server-development`.
4. If you want to see the Account system in action, you will need to setup Mailgun. Adjust the `MAILGUN_PRIVATE_API_KEY` and `MAILGUN_DOMAIN` variables with your specific details.
5. Go to Xcode and run the `Server` executable target.
 
## Related projects

### The coenttb stack

* [swift-css](https://www.github.com/coenttb/swift-css): A Swift DSL for type-safe CSS.
* [swift-html](https://www.github.com/coenttb/swift-html): A Swift DSL for type-safe HTML & CSS, integrating [swift-css](https://www.github.com/coenttb/swift-css) and [pointfree-html](https://www.github.com/coenttb/pointfree-html).
* [swift-web](https://www.github.com/coenttb/swift-web): Foundational tools for web development in Swift.
* [coenttb-html](https://www.github.com/coenttb/coenttb-html): Builds on [swift-html](https://www.github.com/coenttb/swift-html), and adds functionality for HTML, Markdown, Email, and printing HTML to PDF.
* [coenttb-web](https://www.github.com/coenttb/coenttb-web): Builds on [swift-web](https://www.github.com/coenttb/swift-web), and adds functionality for web development.
* [coenttb-server](https://www.github.com/coenttb/coenttb-server): Build fast, modern, and safe servers that are a joy to write. `coenttb-server` builds on [coenttb-web](https://www.github.com/coenttb/coenttb-web), and adds functionality for server development.
* [coenttb-vapor](https://www.github.com/coenttb/coenttb-server-vapor): `coenttb-server-vapor` builds on [coenttb-server](https://www.github.com/coenttb/coenttb-server), and adds functionality and integrations with Vapor and Fluent.
* [coenttb-com-server](https://www.github.com/coenttb/coenttb-com-server): The backend server for coenttb.com, written entirely in Swift and powered by [coenttb-server-vapor](https://www.github.com/coenttb-server-vapor).

### PointFree foundations
* [coenttb/pointfree-html](https://www.github.com/coenttb/pointfree-html): A Swift DSL for type-safe HTML, forked from [pointfreeco/swift-html](https://www.github.com/pointfreeco/swift-html) and updated to the version on [pointfreeco/pointfreeco](https://github.com/pointfreeco/pointfreeco).
* [coenttb/pointfree-web](https://www.github.com/coenttb/pointfree-html): Foundational tools for web development in Swift, forked from  [pointfreeco/swift-web](https://www.github.com/pointfreeco/swift-web).
* [coenttb/pointfree-server](https://www.github.com/coenttb/pointfree-html): Foundational tools for server development in Swift, forked from  [pointfreeco/swift-web](https://www.github.com/pointfreeco/swift-web).

### Other
* [swift-languages](https://www.github.com/coenttb/swift-languages): A cross-platform translation library written in Swift.

## Feedback is much appreciated!
  
If you’re working on your own Swift web project, feel free to learn, fork, and contribute.

Got thoughts? Found something you love? Something you hate? Let me know! Your feedback helps make this project better for everyone. Open an issue or start a discussion—I’m all ears.

> [Subscribe to my newsletter](http://coenttb.com/en/newsletter/subscribe)
>
> [Follow me on X](http://x.com/coenttb)
> 
> [Link on Linkedin](https://www.linkedin.com/in/tenthijeboonkkamp)

## License

The paid content of [coenttb.com](https://coenttb.com), including text, images, and other media, is all rights reserved.
Unauthorized use, reproduction, or distribution of this content is prohibited without prior permission.

All other content (such as blog posts, documentation, and media not part of paid content) is licensed under [CC BY-NC-SA 4.0 LICENSE](CC%20BY-NC-SA%204.0%20LICENSE).

This project's source code, excluding content of coenttb.com, is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**.
You are free to use, modify, and distribute it under the terms of the AGPL-3.0.
For full details, please refer to the [LICENSE](LICENSE) file.

### Commercial Licensing

A **Commercial License** is available for organizations or individuals who wish to use this project without adhering to the terms of the AGPL-3.0. This option is ideal for:
- Using the codebase in proprietary software
- Incorporating it into SaaS products
- Avoiding the source code sharing requirements of AGPL-3.0

For inquiries about commercial licensing, please contact **info@coenttb.com**.
