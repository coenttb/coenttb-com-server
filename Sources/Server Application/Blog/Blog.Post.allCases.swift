//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/08/2024.
//

import Coenttb_Web
import CoenttbMarkdown
import Coenttb_Blog
import Coenttb_Server_HTML
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
        

            .filter {
                @Dependency(\.date.now) var now
                @Dependency(\.envVars.appEnv) var env
                
                return switch env {
                case .production, .staging:
                    $0.publishedAt <= now
                case .development, .testing:
                    true
                }
            }
            .sorted(by: { $0.publishedAt < $1.publishedAt })
    }
}

extension [Coenttb_Blog.Blog.Post] {
    package static var general: [Coenttb_Blog.Blog.Post] {
        process {
            category,
            index in
            [
                .init(
                    id: .init(),
                    index: index(),
                    category: category,
                    publishedAt: .init(year: 2024, month: 12, day: 16)!,
                    image: div {
                        Image.coenttbGreenSuit
                            .dependency(\.objectStyle.position, .y(15.percent))
                    }.position(.absolute),
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
                    index: index(),
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
                    index: index(),
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
                    index: index(),
                    category: category,
                    publishedAt: .init(year: 2025, month: 04, day: 06)!,
                    image: position(asset: "coenttb-20250324.png")
                        .inlineStyle("filter", "sepia(1) hue-rotate(225deg) saturate(5) brightness(1.2)"),
                    title: "A Tour of CSS",
                    hidden: .no,
                    blurb: """
                        Swift-css gives you the type safety of Swift for your CSS. No more hunting down styling bugs—catch them at compile time instead. This library models CSS concepts as Swift types, making your styles as reliable as your Swift code.
                          Perfect for developers who love the safety and tooling of Swift but need to work with CSS styling.
                        """,
                    estimatedTimeToComplete: 30.minutes,
                    permission: .free
                ),
                
            ]
        }
    }
}
@HTMLBuilder
func position(
    asset: String,
    x: Length = 50.percent,
    y: Length = 50.percent
    
) -> some HTML {
    div {
        @Dependency(\.coenttb.website.router) var serverRouter
        div {
            Image(
                source: serverRouter.href(for: .asset(.image(.init(stringLiteral: asset)))),
                description: "coenttb avatar"
            )
            .objectFit(.cover)
            .width(100.percent)
            .height(100.percent)
            .objectPosition(x: x, y: y)
        }
        .size(width: 100.percent, height: 100.percent)
        .position(.absolute)
    }
}

extension [Coenttb_Blog.Blog.Post] {
    package static var domain_modeling: [Coenttb_Blog.Blog.Post] {
        process("domain-modeling") { category, index in
            [
                .init(
                    id: .init(),
                    index: index(),
                    category: category,
                    publishedAt: .init(year: 2024, month: 12, day: 23)!,
                    image: div {
                        Image.coenttbGreenSuit.dependency(\.objectStyle.position, .y(15.percent))
                            .inlineStyle("filter", "sepia(1) hue-rotate(-50deg) saturate(5) brightness(1.2)")
                    }.position(.absolute),
                    title: TranslatedString(
                        dutch: "Van complexiteit naar helderheid: een gelaagde aanpak voor API domeinmodeling in Swift",
                        english: "From complexity to clarity: a layered approach to API domain modeling design in Swift"
                    ).description,
                    hidden: .no,
                    blurb: """
                    \(
                        TranslatedString(
                            dutch: """
                            Ontdek hoe het scheiden van je API-code in verschillende lagen — robuuste funderingen en gebruiksvriendelijke interfaces — complexe integraties kan transformeren naar onderhoudbare, typeveilige Swift-code. Leer aan de hand van een praktische Mailgun-implementatie hoe deze aanpak bugs elimineert en ontwikkelaars daadwerkelijk geeft in het werken met deze API.
                            """,
                            english: """
                            Discover how separating your API code into distinct layers—rock-solid foundations and developer-friendly interfaces—can transform complex integrations into maintainable, type-safe Swift code. Through a real-world Mailgun implementation, learn how this approach eliminates bugs while making developers actually enjoy working with this API.
                            """
                        )
                    )
                    """,
                    estimatedTimeToComplete: 20.minutes,
                    permission: .free
                ),
            ]
        }
    }
}

fileprivate func process(
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
