//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/08/2024.
//

import Coenttb_Com_Shared
import Coenttb_Web_HTML
import Dependencies
import Foundation

package struct CoenttbNavigationBar: HTML {

    package init() {}

    @Dependency(\.coenttb.website.router) var serverRouter
    @Dependency(\.blog.getAll) var blogPosts
    @Dependency(\.currentUser) var currentUser

    private var blog: String { serverRouter.href(for: .blog(.index)) }
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

        NavigationBar(
            logo: {
                CoenttbLogo()
                .height(.percent(100))
            },
            centeredNavItems: {
                NavigationBarCenteredNavItems(
                    items: [
                        !posts.isEmpty ? .init(String.blog.capitalizingFirstLetter().description, href: .init(blog)) : nil,
                        .init(String.contact_me.capitalizingFirstLetter().description, href: .init(serverRouter.href(for: .contact)))
                    ].compactMap { $0 }
                )
                .dependency(\.color.text.link, .text.primary)

            },
            trailingNavItems: {
                HTMLEmpty()
            },
            mobileNavItems: {
                ul {
                    HTMLGroup {
                        HTMLForEach([
                            !posts.isEmpty ? NavigationBarMobileNavItems.NavListItem("Blog", href: .init(blog)) : nil
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
//                                    href: serverRouter.href(for: .account(.settings(.index)))
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

extension CoenttbNavigationBar {
    package struct CoenttbLogo: HTML {

        @Dependency(\.coenttb.website.router) var serverRouter

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

                        Link(href: .init(serverRouter.href(for: .home))) {
                            SVG.coenttb()
                        }
                        .dependency(\.color.text.link, .text.primary)
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
