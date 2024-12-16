//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/08/2024.
//

import CoenttbHTML
import CoenttbMarkdown
import CoenttbWebBlog
import CoenttbWebHTML
import Date
import Dependencies
import Foundation
import Languages

extension [CoenttbWebBlog.Blog.Post] {

    public static let all: [CoenttbWebBlog.Blog.Post] = [
        .init(
            id: .init(),
            index: 1,
            publishedAt: .now,
            image: Image.coenttbGreenSuit.dependency(\.objectStyle.position, .y(30.percent)),
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
        )
    ]
}
