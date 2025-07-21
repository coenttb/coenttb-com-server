//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/08/2024.
//

import Coenttb_Blog
import Coenttb_Server_HTML
import Coenttb_Web
import CoenttbMarkdown
import Date
import Dependencies
import Foundation
import Languages

extension [Coenttb_Blog.Blog.Post] {
    package static var allCases: [Coenttb_Blog.Blog.Post] {
        Array {
            [Coenttb_Blog.Blog.Post].general
            //            [Coenttb_Blog.Blog.Post].html,
            //            [Coenttb_Blog.Blog.Post].domain_modeling,
        }
    }
}

extension [Coenttb_Blog.Blog.Post] {
    package static var general: [Coenttb_Blog.Blog.Post] {
        process {
            category,
            _ in
            [
                .init(
                    id: .init(),
                    index: 1,
                    category: category,
                    publishedAt: .init(year: 2024, month: 12, day: 16)!,
                    image: position(
                        asset: "coenttb-halftone.png",
                        y: .percentage(15)
                    ),
                    title: TranslatedString(
                        dutch: "Van blut naar build in public: open source coenttb.com",
                        english: "From broke to building in public: open-sourcing coenttb.com"
                    ).description,
                    hidden: .no,
                    blurb: """
                    \(
                        TranslatedString(
                            dutch: """
                            Start-up gebouwd. Blut gegaan. Ziel verkocht. Nog een startup gebouwd. Bijna weer blut. Toen op reset gedrukt, mezelf opnieuw uitgevonden in de life sciences, en nu bouw ik mijn eigen ding—legal tech in Swift, en ik deel de reis.

                            Ik open-source **coenttb.com**, mijn Swift Vapor-website, omdat van scratch beginnen zwaar overrated is. Swift voor web is *moeilijk*, maar hoeft niet eenzaam te zijn.

                            Volg voor legal tech, Swift-tips en lessen van (bijna) twee keer blut gaan.

                            > 👉 [Nieuwsbrief](http://coenttb.com/en/newsletter/subscribe) | [Repo](https://github.com/coenttb/coenttb-com-server) | [X](http://x.com/coenttb)
                            """,
                            english: """
                            Built a startup. Went broke. Sold soul. Built another startup. Almost went broke *again*. Hit reset, leveled up in life sciences, and now I’m doing my own thing—coding legal tech with Swift and sharing the grind.

                            I’m open-sourcing **coenttb.com**, my Swift Vapor website, because starting from scratch is overrated. Swift for web is *hard*, but it doesn’t have to be lonely.

                            Follow for legal tech, Swift tips, and lessons from almost going broke (twice).

                            > 👉 [Newsletter](http://coenttb.com/en/newsletter/subscribe) | [Repo](https://github.com/coenttb/coenttb-com-server) | [X](http://x.com/coenttb)
                            """
                        )
                    )
                    """,
                    estimatedTimeToComplete: 5.minutes,
                    permission: .free
                ),
                .init(
                    id: .init(),
                    index: 2,
                    category: category,
                    publishedAt: .init(year: 2025, month: 03, day: 21)!,
                    image: position(asset: "coenttb-20250320.png")
                        .inlineStyle("filter", "sepia(1) hue-rotate(-25deg) saturate(5) brightness(1.2)"),
                    title: "A journey building HTML documents in Swift",
                    hidden: .no,
                    blurb: """
                        Let’s explore generating HTML in Swift—moving beyond brittle string interpolation and cumbersome formatting. Learn how tools like Plot and PointFreeHTML bring type-safety and elegance to document creation, and how code can be used to eliminate repetitive (legal) tasks.
                        """,
                    estimatedTimeToComplete: 15.minutes,
                    permission: .free
                ),
                .init(
                    id: .init(),
                    index: 3,
                    category: category,
                    publishedAt: .init(year: 2025, month: 03, day: 24)!,
                    image: position(asset: "coenttb-20250324.png")
                        .inlineStyle("filter", "sepia(1) hue-rotate(225deg) saturate(5) brightness(1.2)"),
                    title: "A Tour of PointFreeHTML",
                    hidden: .no,
                    blurb: """
                        Let’s take a tour through `pointfree-html`'s API for generating HTML documents. We will discover how its HTML protocol composes HTML components using recursive rendering and appreciate its handling of attributes and styles—all while delivering blazing-fast performance. This library has made working with HTML much more pleasant for me, both for web content and everyday legal documents. I’m confident you'll agree with me.
                        """,
                    estimatedTimeToComplete: 40.minutes,
                    permission: .free
                ),
                .init(
                    id: .init(),
                    index: 4,
                    category: "Modern Swift Library Architecture",
                    publishedAt: .init(year: 2025, month: 07, day: 10)!,
                    image: position(asset: "coenttb-20250710.png"),
                    title: "1 The Swift Package",
                    hidden: .no,
                    blurb: """
                        Ever found yourself trapped maintaining a giant Swift monolith? There’s a better way. Discover how modular Swift package design lets you break down complexity, speed up testing, and dramatically simplify maintenance. Let’s explore modern Swift architectures together—one package at a time.
                        """,
                    estimatedTimeToComplete: 30.minutes,
                    permission: .free
                ),
                .init(
                    id: .init(),
                    index: 5,
                    category: "Modern Swift Library Architecture",
                    publishedAt: .init(year: 2025, month: 07, day: 14)!,
                    image: position(asset: "coenttb-20250714.png"),
                    title: "2 Composition of Packages",
                    hidden: .no,
                    blurb: """
                        When single-package modularity isn't enough, it's time to embrace composition of packages. Discover how to architect Swift library ecosystems that enable independent evolution, flexible integration, and possibilities you haven't imagined yet.
                        """,
                    estimatedTimeToComplete: 30.minutes,
                    permission: .free
                ),
                .init(
                    id: .init(),
                    index: 6,
                    category: "Modern Swift Library Architecture",
                    publishedAt: .init(year: 2025, month: 07, day: 21)!,
                    image: position(asset: "coenttb-20250721.png"),
                    title: "3 Testing a composition of packages",
                    hidden: .no,
                    blurb: """
                        Testing doesn’t have to be a tangled mess. Discover how modular Swift package architecture transforms testing—from brittle and slow to fast, focused, and intuitive. We’ll walk through real-world and show how adding dark mode touched only one test suite in one package. Yes, really.
                        """,
                    estimatedTimeToComplete: 20.minutes,
                    permission: .free
                )
            ]
        }
    }
}

@HTMLBuilder
func position(
    asset: String,
    x: LengthPercentage = .percent(50),
    y: LengthPercentage = .percent(50)
) -> some HTML {
    div {
        @Dependency(\.coenttb.website.router) var serverRouter
        div {
            Image(
                src: .init(serverRouter.href(for: .asset(.image(.init(stringLiteral: asset))))),
                alt: "coenttb avatar",
                loading: .lazy
            )
            .objectFit(.cover)
            .width(.percent(100))
            .maxWidth(.percent(100))
            .height(.percent(100))
            .objectPosition(.twoValues(.init(x), .init(y)))
        }
        .width(.percent(100))
        .height(.percent(100))
        .position(.absolute)
    }
}

private func process(
    _ category: TranslatedString? = nil,
    _ closure: (_ category: TranslatedString?, _ index: () -> Int) -> [Coenttb_Blog.Blog.Post]
) -> [Coenttb_Blog.Blog.Post] {
    var counter = 0
    let incrementingIndex: () -> Int = {
        counter += 1
        return counter
    }

    return closure(category, incrementingIndex)
}
