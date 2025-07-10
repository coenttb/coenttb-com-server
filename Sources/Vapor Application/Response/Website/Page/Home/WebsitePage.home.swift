//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 30/05/2022.
//

import Coenttb_Vapor
import Server_Application
import Coenttb_Blog
import Coenttb_Newsletter
import Coenttb_Com_Shared
import Server_Translations
import Coenttb_Com_Router

extension WebsitePage {
    public static func home() async throws -> any AsyncResponseEncodable {
        @Dependency(\.language) var translated
        @Dependency(\.coenttb.website.router) var serverRouter
        @Dependency(\.blog.getAll) var blogPosts
        @Dependency(\.currentUser) var currentUser
        @Dependency(\.request) var request

        let posts = blogPosts()
        let newsletterSubscribed = currentUser?.newsletterSubscribed == true || (currentUser?.newsletterSubscribed == nil && request?.cookies[.newsletterSubscribed]?.string == "true")

        return Server_Application.DefaultHTMLDocument {
            HTMLGroup {
                                
                if currentUser?.authenticated != true {
                    CallToActionModule(
                        title: (
                            content: "\(String.oneliner)",
                            color: .text.primary
                        ),
                        blurb: (
                            content: """
                            \(String.hi_my_name_is_Coen_ten_Thije_Boonkkamp.capitalizingFirstLetter()). \(String.website_introduction.capitalizingFirstLetter().period)
                            \((!posts.isEmpty ? " \(String.follow_my_blog_for.capitalizingFirstLetter().period)" : ""))
                            """,
                            color: .text.primary
                        )
                    )
                    .if(currentUser?.authenticated != true) {
                        $0.gradient(
                            bottom: .background.primary,
                            middle: .gradientMidpoint(from: .background.primary, to: .branding.accent)!,
                            top: .branding.accent
                        )
                    }
                }

                if !posts.isEmpty {
                    div {
                        Coenttb_Blog.Blog.FeaturedModule2(
                            posts: posts,
                            seeAllURL: serverRouter.url(for: .blog(.index))
                        )
                    }
                    .if(currentUser?.authenticated == true) {
                        $0.gradient(
                            bottom: .background.primary,
                            middle: .gradientMidpoint(from: .background.primary, to: .branding.accent)!,
                            top: .branding.accent
                        )
                    }
//                    .background(currentUser?.authenticated == true ? .background : .offBackground)
                    .backgroundColor(.background.primary)
                }

                if newsletterSubscribed != true {
                    div {
                        PageModule(theme: .newsletterSubscription) {
                            VStack {
                                CoenttbHTML.Paragraph {
                                    String.periodically_receive_articles_on.capitalizingFirstLetter().period
                                }
                                .textAlign(.center, media: .desktop)

                                @Dependency(\.newsletter.subscribeAction) var subscribeAction
                                
                                NewsletterSubscriptionForm(
                                    subscribeAction: subscribeAction()
                                )
                                .width(.percent(100))
                            }
                            .width(.percent(100))
                            .maxWidth(.rem(30), media: .desktop)
                            .flexContainer(
                                direction: .column,
                                wrap: .wrap,
                                justification: .center,
                                itemAlignment: .center,
                                rowGap: .rem(0.5)
                            )
                        }
                        title: {
                            Header(4) {
                                String.subscribe_to_my_newsletter.capitalizingFirstLetter()
                            }
                            .padding(top: .rem(3))
                        }
                        .flexContainer(
                            justification: .center,
                            itemAlignment: .center,
                            media: .desktop
                        )
                        .flexContainer(
                            justification: .start,
                            itemAlignment: .start,
                            media: .mobile
                        )
                    }
//                    .background(currentUser?.authenticated == true ? .background.primary : .background.secondary)
                    .width(.percent(100))
                    .id("newsletter-signup")
                }

                CallToActionModule(
                    title: (
                        content: TranslatedString(
                            dutch: "Ontdek de rol van legal in het succes van life science projecten",
                            english: "Discover the role of legal in the success of life science projects"
                        ).description,
                        color: .text.primary
                    ),
                    blurb: (
                        content: #"""
                        \#(
                            TranslatedString(
                                dutch: "Ten Thije Boonkkamp is waar ik mijn persoonlijke juridische dienstverlening voor life science projecten aanbiedt",
                                english: "Ten Thije Boonkkamp is where I offer my personal legal services for life science projects"
                            ).period
                        )
                        """#,
                        color: .text.primary
                    )
                ) {
                    div {
                        div {
                            Link(href: .init("https://tenthijeboonkkamp.nl")) {
                                Label {
                                    span { FontAwesomeIcon(icon: "scale-balanced") }
                                        .color(.branding.primary)
                                        .fontWeight(.medium)
                                } title: {
                                    div {
                                        HTMLText("tenthijeboonkkamp.nl" + " →")
                                    }
                                    .color(.branding.primary)
                                    .fontWeight(.medium)
                                }
                            }
                            
//                            Button(
//                                tag: a,
//                                style: .default,
//                                icon: {
//                                    span { FontAwesomeIcon(icon: "scale-balanced") }
//                                        .color(.branding.primary)
//                                        .fontWeight(.medium)
//                                },
//                                label: {
//                                    div {
//                                        HTMLText("tenthijeboonkkamp.nl" + " →")
//                                    }
//                                    .color(.branding.primary)
//                                    .fontWeight(.medium)
//
//                                }
//                            )
//                            .href("https://tenthijeboonkkamp.nl")
                        }
                        .display(.inlineBlock)
                        .margin(top: .rem(3))
                    }
                }
//                .background(currentUser?.authenticated == true ? .offBackground : .background)
                .backgroundColor(.background.primary)

            }
        }
    }
}

extension Blog {
    public struct FeaturedModule2: HTML {

        let posts: [Blog.Post]
        let seeAllURL: URL
        
        public init(
            posts: [Blog.Post],
            seeAllURL: URL
        ) {
            self.posts = posts
            self.seeAllURL = seeAllURL
        }
       

        var columns: [Int] {
            switch posts.count {
            case ...1: [1]
            case 2: [1, 1]
            default: [1, 1, 1]
            }
        }
        
        @Dependency(\.language) var language


        public var body: some HTML {
            PageModule(
                theme: .content
            ) {
                VStack {
                    LazyVGrid(
                        columns: [.desktop: columns],
                        horizontalSpacing: .rem(1),
                        verticalSpacing: .rem(1)
                    ) {
                        HTMLForEach(posts.suffix(3).reversed()) { post in
                            Blog.Post.Card2(post)
                                .maxWidth(.rem(24), media: .desktop)
                                .margin(top: .rem(1), right: 0, bottom: .rem(2), left: 0)
                        }
                    }
                }
            } title: {
                PageModuleSeeAllTitle(title: String.all_posts.capitalizingFirstLetter().description, seeAllURL: seeAllURL.absoluteString)
                    .padding(bottom: .rem(2))
            }
        }
    }
}

extension Blog.Post {
    public struct Card2: HTML {
        @Dependency(\.date.now) var now
        @Dependency(\.language) var language
        
        let post: Blog.Post
        
        let href: URL?
        
        public init(
            _ post: Blog.Post
        ) {
            self.post = post
//            self.href = URL(string: "#")
            @Dependency(\.blog) var blogClient
            self.href = blogClient.postToRoute(post)
        }
        
        public var body: some HTML {
            CoenttbHTML.Card {
                VStack {
                    
                    VStack(
                        spacing: .rem(0.5)
                    ) {
                        div {
                            HTMLText("Blog \(post.index)\(post.category.map { " \($0.description)" } ?? "") - \(post.publishedAt.formatted(date: .complete, time: .omitted))")
                        }
                        .color(.text.tertiary)
                        .font(.body(.small))
                        
                        div {
                            if let href {
                                Header(4) {
                                    Link(href: .init(href.absoluteString)) {
                                        HTMLText(post.title)
                                        if let subtitle = post.subtitle {
                                            ":"
                                            br()
                                            HTMLText(subtitle)
                                        }
                                    }
                                    .linkColor(.text.primary)
                                }
                            }
                        }
                    }

                    
                    HTMLMarkdown(post.blurb)
                        .color(.text.primary)
                        .linkStyle(.init(underline: true))
                        .dependency(\.color.text.link, .gray400.withDarkColor(.gray650))
                }
            }
            header: {
                if let href {
                    CoenttbHTML.Link(href: .init(href.absoluteString)) {
                        div {
                            div {
                                AnyHTML(post.image)
                                    .width(.percent(100))
                                    .height(.percent(100))
                                    .objectFit(.cover)
                            }
                            .position(
                                .absolute,
                                top: .zero,
                                right: nil,
                                bottom: nil,
                                left: .zero,
                            )
                            .width(.percent(100))
                            .height(.percent(100))
//                            .size(
//                                width: .percent(100),
//                                height: .percent(100)
//                            )
                        }
                        .position(.relative)
                        .width(.percent(100))
                        .height(.px(300))
//                        .size(
//                            width: .percent(100),
//                            height: .px(300)
//                        )
                        .overflow(.hidden)
                    }
                }
                
            }
            footer: {
                Blog.Post.Card.Footer2 {
                    switch post.permission {
                    case .free:
                        Label(fa: "lock-open") {
                            String.free
                        }
                    case .subscriberOnly:
                        Label(fa: "lock") {
                            String.subscriber_only
                        }
                    }
                    
                    Label(fa: "clock") {
                        TranslatedString(self.post.estimatedTimeToComplete)
                        
                    }
                }
                .fontSize(.secondary)
            }
            .backgroundColor(.cardBackground)
        }
    }
}

extension Blog.Post.Card {
    struct Footer2<Content: HTML>: HTML {
        @HTMLBuilder let content: Content
        var body: some HTML {
            HStack(alignment: .center) {
                content
            }
            .color(.gray650.withDarkColor(.gray400))
            .linkColor(.gray650.withDarkColor(.gray400))
        }
    }
}


//                PageModule(theme: .content) {
//                    div {
//                        div {
//                            div {
//                                Image.prehalftone
//                                    .inlineStyle("filter", "sepia(0.8) hue-rotate(-260deg) saturate(3) brightness(1.15) contrast(1.2)")
//                                    .halftone(
//                                        dotSize: .em(0.3),                    // Smaller dots for more detail
//                                        lineColor: .black.withDarkColor(.white),
//                                        lineContrast: 1500,                    // Reduce contrast for smoother gradients
//                                        photoBrightness: 90,                  // Slight brightness boost
//                                        photoContrast: 110,                    // Increase contrast for better definition
//                                        photoBlur: .px(0.5),                   // Less blur to retain detail
//                                        blendMode: .overlay,                  // Try multiply or overlay for better blending
//                                        rotationAngle: 15                      // Slightly less rotation
//                                    )
//                            }
//                            .overflow(.hidden)
//                        }
//                        .height(.px(300))
//                        .width(.px(384))
//                    }
//                    .position(.relative)
//                }
