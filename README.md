# coenttb.com - Swift Vapor website in the style of PointFree

`coenttb-com-server` is the source code for [coenttb.com](https://coenttb.com), written entirely in Swift in the style of [PointFree](https://www.github.com/pointfreeco/pointfreeco) and powered by [Vapor](https://www.github.com/vapor/vapor) & [coenttb-web](https://www.github.com/coenttb/coenttb-web).

Read more about me in my [introductory post on coenttb.com](https://www.coenttb.com/blog/1-from-broke-to-building-in-public-open-sourcing-coenttb-com).

## About the project

Building a website in Swift? It’s *fun*. It’s *clean*. It’s also *painful*. 

As a lawyer who writes code, I’ve spent years experimenting with rules as code and have a lot to share. But I didn’t want to be limited to iOS apps—I wanted to reuse my existing Swift code for the web. Building a website in Swift? It’s *fun*. It’s *clean*. It’s *painful*, but also: incredibly rewarding. Writing this site entirely in Swift, powered by PointFree & Vapor, forced me to push boundaries, embrace functional programming, and rethink how web development could work.

### Key Features
- **Built entirely in Swift**: No JavaScript frameworks, no CSS hacks. Just cross platform Swift and Vapor.
- **Functional elegance**: Clean architecture inspired by PointFree's best practices.
- **Hypermodular**: Each module integrates only the parts that it needs.

## Why open source?

Building in Swift for the web is both rewarding and frustrating. I’ve made mistakes, learned from them, and found ways to overcome challenges unique to Swift web development. By open-sourcing this project, I hope to:
1. Show how to structure a Swift Vapor website *elegantly*.
2. Save you the trial-and-error grind.
3. Get feedback to make it even better.  

Plus, I feel like I owe it to the PointFree guys.

## Getting started

1. Clone the repo.
2. Copy the `.env.example` file and rename it `.env.development`.
3. Start a [postgres server](https://www.postgresql.org/download/). Adjust the `DATABASE_URL` variable in your `.env.development` to whatever you name your server. If your server is called `example-com-server-development`, on `port 5432`, on `localhost`, with a database user named `admin` then the correct syntax is `postgres://admin:@localhost:5432/example-com-server-development`.
4. If you want to see the Account system in action, you will need to setup Mailgun. Adjust the `MAILGUN_PRIVATE_API_KEY` and `MAILGUN_DOMAIN` variables with your specific details.
5. Go to Xcode and run the `Server` executable target.
 
## Related projects

* [coenttb/pointfree-html](https://www.github.com/coenttb/coenttb/pointfree-html): A Swift DSL for type-safe HTML forked from [pointfreeco/swift-html](https://www.github.com/pointfreeco/swift-html) and updated to the version on [pointfreeco/pointfreeco](https://github.com/pointfreeco/pointfreeco).
* [swift-css](https://www.github.com/coenttb/swift-css): A Swift DSL for type-safe CSS.
* [swift-html](https://www.github.com/coenttb/swift-html): A Swift DSL for type-safe HTML & CSS, integrating [swift-css](https://www.github.com/coenttb/swift-css) and [pointfree-html](https://www.github.com/coenttb/pointfree-html).
* [coenttb-html](https://www.github.com/coenttb/coenttb-html): Extends [swift-html](https://www.github.com/coenttb/swift-html) with additional functionality and integrations for HTML, Markdown, Email, and printing HTML to PDF.
* [swift-web](https://www.github.com/coenttb/swift-web): Modular tools to simplify web development in Swift forked from  [pointfreeco/swift-web](https://www.github.com/pointfreeco/swift-web), and updated for use in [coenttb-web](https://www.github.com/coenttb/coenttb-web).
* [coenttb-web](https://www.github.com/coenttb/coenttb-web): A collection of features for your Swift server, with integrations for Vapor.
* [coenttb-com-server](https://www.github.com/coenttb/coenttb-com-server): The backend server for coenttb.com, written entirely in Swift and powered by [Vapor](https://www.github.com/vapor/vapor) and [coenttb-web](https://www.github.com/coenttb/coenttb-web).
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

The content of [coenttb.com](https://coenttb.com), including text, images, and other media, is all rights reserved. Unauthorized use, reproduction, or distribution of the content is prohibited without prior permission.

This project, excluding content of coenttb.com, is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**.  
You are free to use, modify, and distribute it under the terms of the AGPL-3.0.  
For full details, please refer to the [LICENSE](LICENSE) file.

### Commercial Licensing

A **Commercial License** is available for organizations or individuals who wish to use this project without adhering to the terms of the AGPL-3.0 (e.g., to use it in proprietary software or SaaS products).

For inquiries about commercial licensing, please contact **info@coenttb.com**.
