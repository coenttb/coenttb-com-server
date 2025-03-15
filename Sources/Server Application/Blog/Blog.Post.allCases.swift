//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/08/2024.
//

import CoenttbHTML
import CoenttbMarkdown
import Coenttb_Blog
import Coenttb_Server_HTML
import Date
import Dependencies
import Foundation
import Languages

extension [Coenttb_Blog.Blog.Post] {
    package static var allCases: [Coenttb_Blog.Blog.Post] {
        [
            [Coenttb_Blog.Blog.Post].general,
            [Coenttb_Blog.Blog.Post].domain_modeling,
            [Coenttb_Blog.Blog.Post].html,
        ]
            .flatMap{ $0 }
            .sorted(by: { $0.publishedAt < $1.publishedAt })
    }
}

extension [Coenttb_Blog.Blog.Post] {
    package static var general: [Coenttb_Blog.Blog.Post] {
        process { category, index in
            [
                .init(
                    id: .init(),
                    index: index(),
                    category: category,
                    publishedAt: .init(year: 2024, month: 12, day: 16)!,
                    image: div { Image.coenttbGreenSuit.dependency(\.objectStyle.position, .y(15.percent)) }.position(.absolute),
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
            ]
        }
    }
}

extension [Coenttb_Blog.Blog.Post] {
    package static var domain_modeling: [Coenttb_Blog.Blog.Post] {
        process("domain-modeling") {
            category,
            index in
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

extension [Coenttb_Blog.Blog.Post] {
    package static var html: [Coenttb_Blog.Blog.Post] {
        process("html") {
            category,
            index in
            [
                .init(
                    id: .init(),
                    index: index(),
                    category: category,
                    publishedAt: .init(year: 2025, month: 03, day: 13)!,
                    image: div {
                        Image.coenttbGreenSuit.dependency(\.objectStyle.position, .y(15.percent))
                            .inlineStyle("filter", "sepia(1) hue-rotate(-50deg) saturate(5) brightness(1.2)")
                    }.position(.absolute),
                    title: TranslatedString(
                        dutch: "",
                        english: "Modern HTML DSL in swift: pointfree-html as foundation"
                    ).description,
                    hidden: .no,
                    blurb: """
                    \(
                        TranslatedString(
                            dutch: """
                            
                            """,
                            english: """
                            Explore the foundations of a modern HTML DSL in swift.
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
