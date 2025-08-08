//  Email.newsletter6.swift
//  newsletter6
//
//  Created by Coen ten Thije Boonkkamp on [DATE]
//

import Coenttb_Web
import Mailgun

extension Email {
    package static func newsletter6(

    ) -> any EmailDocument {

        @Dependency(\.coenttb.website.router) var router
        let index = 6
        let title = "#\(index) Modern Swift Library Architecture: Testing a Composition of Packages"

        return TableEmailDocument(
            preheader: title
        ) {
            tr {
                td {
                    VStack(alignment: .center) {
                        Header(3) {
                            "coenttb "
                            title
                        }

                        Circle {
                            Image(
                                src: .init(router.url(for: .public(.asset(.image("coenttb-20250721.png")))).absoluteString),
                                alt: "coenttb image"
                            )
                            .objectPosition(.twoValues(.percentage(50), .percentage(50)))
                        }
                        .margin(.auto)
                        .padding(top: .large, bottom: .large)

                        VStack(alignment: .leading) {

                            EmailMarkdown {"""
                            Picture this: you're maintaining a Swift library and need to add a new feature. You write the code, then turn to the tests... and groan. The test suite is a tangled mess where changing one thing breaks tests in completely unrelated areas. Sound familiar?

                            I've found that modularization has interesting consequences for your tests.

                            In today's article '\(title)', I share how breaking my Swift libraries into focused packages helped simplify testing by narrowing scope, and enables features like parallel testing.
                            Test it out for yourself!
                            """}

                            Link(href: .init(router.url(for: .blog(.post(id: index))).absoluteString)) {
                                "Read the full article →"
                            }
                            .color(.text.primary.reverse())
                            .padding(bottom: .medium)

                            Header(4) {
                                "Personal note"
                            }

                            EmailMarkdown {"""
                            I never did believe much in testing. I lean towards functional programming with value types that seem to be proven as written. Why test them further?
                            As I was building larger and more complex systems however, I reached a point where the mental load considering the whole codebase simply became too much. So I explored testing and found a lot to like. And dislike. Over time, I realized that modularity in my packages and across packages meant I had no choice but to be very focussed in my tests, which made them easier to write, easier to maintain, and—most importantly—made me want to write them (or have AI write them).
                            These days, I feel great every time the thousand+ tests run cleanly and pass, giving me that much more confidence in my code-base.
                            """}

                            CoenttbHTML.Paragraph {
                                "You are receiving this email because you have subscribed to this newsletter. If you no longer wish to receive emails like this, you can unsubscribe "
                                Link("here", href: "%mailing_list_unsubscribe_url%")
                                "."
                            }
                            .linkColor(.text.secondary)
                            .color(.text.secondary)
                            .font(.footnote)
                        }
                    }
                    .padding(vertical: .small, horizontal: .medium)
                }
            }
        }
    }
}

// REDDIT
// Picture this: you’re maintaining a Swift library and need to add a new feature. You write the code, then open the test suite… and groan. It’s a tangled mess—changing one thing breaks unrelated tests. Sound familiar?
//
// Modularity changes everything.
//
// In Part 3 of my Modern Swift Library Architecture series — “Testing a composition of packages” — I show how breaking my libraries into focused packages made testing not just easier, but actually enjoyable. Scope narrows. Speed increases. Parallel testing becomes effortless.
//
// 👉 [Read the full article →](https://coenttb.com/blog/6)
//
// # Personal note:
//
// I never really believed in testing. I leaned heavily on functional programming and value types—code that felt “proven by construction.”
//
// But as my systems grew, so did the mental load. I reluctantly embraced testing… and slowly came to appreciate it. Not all of it, though.
//
// What changed the game? Modularity. It forced me to write focused, maintainable tests—and made them fast. Now, with 1,000+ tests running in parallel and passing cleanly, I feel more confident in my code than ever.
//
// Give it a read — especially if testing still feels like a chore.
