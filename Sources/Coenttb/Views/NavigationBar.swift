//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/08/2024.
//

import CoenttbWebHTML
import Dependencies
import Foundation
import ServerRouter

public struct CoenttbNavigationBar: HTML {

    public init() {}

    @Dependency(\.serverRouter) var serverRouter
    @Dependency(\.blog.getAll) var blogPosts
    @Dependency(\.currentUser) var currentUser

    private var blog: String { serverRouter.href(for: .blog(.index)) }
    private var loginHref: String { serverRouter.href(for: .account(.login)) }
    private var signupHref: String { serverRouter.href(for: .account(.create(.request))) }
    private var isLoggedIn: Bool { currentUser?.authenticated == true }

    public var body: some HTML {

        let posts = blogPosts()

        let loginButton = Link(
            destination: .account(.login),
            String.login.capitalizingFirstLetter().description
        )
            .linkColor(.coenttbPrimaryColor)
            .linkUnderline(false)
            .fontWeight(.medium)
            .fontSize(.secondary)

        let signupButton = Button(
            tag: a,
            background: .coenttbPrimaryColor,
            style: .tertiary
        ) {
            String.signup.capitalizingFirstLetter()
                .fontWeight(.medium)
        }
            .color(.primary.reverse())
            .href(serverRouter.href(for: .account(.create(.request))))

        NavigationBar(
            logo: {
                CoenttbLogo()
                .height(100.percent)
            },
            centeredNavItems: {
                NavigationBarCenteredNavItems(
                    items: [
                        !posts.isEmpty ? .init(String.blog.capitalizingFirstLetter().description, href: blog) : nil
                    ].compactMap { $0 }
                )
            },
            trailingNavItems: {
                ul {
                    HTMLGroup {
                        if currentUser?.authenticated == true {
                            li {
                                CircleIconButton(
                                    icon: .init(icon: "cog", size: .large),
                                    color: .coenttbPrimaryColor,
                                    href: serverRouter.href(for: .account(.settings(.index))),
                                    buttonSize: 2.5.rem
                                )
                            }

                        } else {
                            li {
                                div {
                                    loginButton
                                }
                                .display(.inlineBlock)
                            }

                            li {
                                div {
                                    signupButton
                                }
                                .display(.inlineBlock)
                            }
                        }
                    }
                    .display(.inline)
                    .padding(left: 1.rem, pseudo: .not(.firstChild))
                }
                .listStyle(.reset)
                .display(.none, media: .mobile)
            },
            mobileNavItems: {
                ul {

                    HTMLGroup {
                        HTMLForEach([
//                            NavigationBarMobileNavItems.NavListItem.init("\(String.services.capitalizingFirstLetter())", href: services),
                            !posts.isEmpty ? NavigationBarMobileNavItems.NavListItem("Blog", href: blog) : nil
                        ].compactMap { $0 }) { item in
                            li {
                                item
                                    .fontWeight(.medium)
                            }
                        }

                        switch currentUser?.authenticated == true {
                        case true:
                            li {
                                NavigationBarMobileNavItems.NavListItem.init(
                                    String.account.capitalizingFirstLetter().description,
                                    href: serverRouter.href(for: .account(.settings(.index)))
                                )
                            }
                            .padding(top: 1.5.rem)

                        case false:
                            li {
                                loginButton
                                    .textAlign(.center)
                                    .display(.block)
                            }
                            .padding(top: 1.5.rem)

                            li {
                                signupButton
                                    .textAlign(.center)
                                    .display(.block)
                            }
                            .padding(top: 1.5.rem)
                        }
                    }
                    .padding(top: 1.5.rem)
                }
            }
        )
        .linkColor(.primary)
    }
}

extension CoenttbNavigationBar {
    public struct CoenttbLogo: HTML {

        @Dependency(\.serverRouter) var serverRouter

        public init() {}

        public var body: some HTML {
            VStack {
                Header(4) {
                    HStack(alignment: .center) {
                        span {
                            div {
                                div {
                                    AnyHTML(
                                        Image.coenttbGreenSuit
                                            .halftone(dotSize: (0.0625 * 2).rem)
                                            .dependency(\.objectStyle.position, .y(30.percent))
                                            .loading(.lazy)
                                    )
                                    .position(.absolute, top: 0, right: 0, bottom: 0, left: 0)
                                }
                                .clipPath(.circle(50.percent))
                                .position(.relative)
                                .size(1.75.rem)
                            }
                        }
                        .display(.flex)
                        .alignItems(.center)

                        Link(href: serverRouter.href(for: .home)) {
                            SVG.coenttb()
                        }
                        .linkStyle(.init(color: .primary, underline: false))
                        .display(.flex)
                        .alignItems(.center)
                    }
                    .alignItems(.center)
                    .height(100.percent)
                }
                .height(100.percent)
            }
        }
    }
}
