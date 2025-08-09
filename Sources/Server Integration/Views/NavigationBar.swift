//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/08/2024.
//

import Coenttb_Com_Router
import Coenttb_Com_Shared
import Coenttb_Web_HTML
import Dependencies
import Foundation

package struct NavigationBar: HTML {

    package init() {}

    @Dependency(\.coenttb.website.router) var router
    @Dependency(\.blog.getAll) var blogPosts
    @Dependency(\.currentUser) var currentUser

    private var blog: String { router.href(for: .blog(.index)) }
    private var projects: String { 
        let page: Coenttb_Com_Router.Route.Website = .projects
        return router.href(for: page) 
    }
    private var isLoggedIn: Bool { currentUser?.authenticated == true }

    package var body: some HTML {

        let posts = blogPosts()

        let subscribeButton = Link(
            destination: .newsletter(.subscribe(.request)),
            String.subscribe_to_my_newsletter.capitalizingFirstLetter().description
        )
            .linkUnderline(false)
            .fontWeight(.medium)
            .font(.body(.small))

        Coenttb_Web_HTML.NavigationBar(
            logo: {
                CoenttbLogo()
                .height(.percent(100))
            },
            centeredNavItems: {
                NavigationBarCenteredNavItems(
                    items: [
                        !posts.isEmpty ? .init(String.blog.capitalizingFirstLetter().description, href: .init(blog)) : nil,
                        .init("Projects", href: .init(projects)),
                        .init(String.contact_me.capitalizingFirstLetter().description, href: .init(router.href(for: .contact)))
                    ].compactMap { $0 }
                )
                .dependency(\.theme.text.link, .text.primary)

            },
            trailingNavItems: {
                ul {
                    li {
                        div {
                            subscribeButton
                        }
                        .display(.inlineBlock)
                    }
                    .display(.inline)
                    .padding(left: .rem(1), pseudo: .not(.firstChild))
                }
                .listStyle(.reset)
                .display(Display.none, media: .mobile)
            },
            mobileNavItems: {
                ul {
                    HTMLGroup {
                        HTMLForEach([
                            !posts.isEmpty ? NavigationBarMobileNavItems.NavListItem("Blog", href: .init(blog)) : nil,
                            NavigationBarMobileNavItems.NavListItem("Projects", href: .init(projects))
                        ].compactMap { $0 }) { item in
                            li {
                                item
                                    .fontWeight(.medium)
                            }
                        }
                        @Dependency(\.currentUser?.newsletterSubscribed) var newsletterSubscribed

                        if newsletterSubscribed != true {
                            li {
                                Link(
                                    destination: .newsletter(.subscribe(.request)),
                                    String.subscribe.capitalizingFirstLetter().description
                                )
                            }
                        }

                        li {
                            Link(
                                destination: .contact,
                                String.contact_me.capitalizingFirstLetter().description
                            )
                        }

//                        switch currentUser?.authenticated == true {
//                        case true:
//                            li {
//                                NavigationBarMobileNavItems.NavListItem.init(
//                                    String.account.capitalizingFirstLetter().description,
//                                    href: router.href(for: .account(.settings(.index)))
//                                )
//                            }
//                            .padding(top: .rem(1.5))
//
//                        case false:
//                            li {
//                                loginButton
//                                    .textAlign(.center)
//                                    .display(.block)
//                            }
//                            .padding(top: .rem(1.5))
//
//                            li {
//                                signupButton
//                                    .textAlign(.center)
//                                    .display(.block)
//                            }
//                            .padding(top: .rem(1.5))
//                        }
                    }
                    .padding(top: .rem(1.5))
                }
            }
        )
    }
}

extension NavigationBar {
    package struct CoenttbLogo: HTML {

        @Dependency(\.coenttb.website.router) var router

        package init() {}

        package var body: some HTML {
            VStack {
                Header(4) {
                    HStack(alignment: .center) {
                        span {
                            Circle(size: .rem(1.75)) {
                                AnyHTML(Image.coenttbGreenSuit)
                                    .objectPosition(.twoValues(.percentage(50), .percentage(50)))
                            }
                            .position(.relative)
                            .flexContainer(
                                justification: .center,
                                itemAlignment: .center
                            )

                        }
                        .display(.flex)
                        .alignItems(.center)

                        Link(href: .init(router.href(for: .home))) {
                            SVG.coenttb()
                        }
                        .dependency(\.theme.text.link, .text.primary)
                        .linkStyle(.init(underline: false))
                        .display(.flex)
                        .alignItems(.center)
                    }
                    .alignItems(.center)
                    .height(.percent(100))
                }
                .height(.percent(100))
            }
        }
    }
}
