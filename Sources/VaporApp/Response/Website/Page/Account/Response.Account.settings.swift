//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/09/2024.
//

import Coenttb
import CoenttbWebAccount
import CoenttbWebHTML
import CoenttbWebStripe
import Foundation
import ServerRouter
import Vapor

func settings(
    settings: WebsitePage.Account.Settings,
    create_customer_portal_session_return_url: URL
) async throws -> AsyncResponseEncodable {
    @Dependency(\.serverRouter) var serverRouter
    
    switch settings {
    case .index:
        return Coenttb.DefaultHTMLDocument(
            scripts: {
                fontAwesomeScript
            },
            navigationBar: { HTMLEmpty() },
            body: {
                StripeContainer(
                    sidebar: .init(
                        background: .coenttbAccentColor,
                        content: {
                            PageModule(theme: .sidebarContent) {
                                HTMLEmpty()
                            } title: {
                                CoenttbNavigationBar.CoenttbLogo()
                                    .height(100.percent)
                                
                                Header(3) {
                                    Link(
                                        destination: .account(.settings(.index)),
                                        String.settings.capitalizingFirstLetter().description
                                    )
                                        .linkUnderline(false)
                                }
                                .textAlign(.left)
                            }
                        }
                    ),
                    main: {
                        PageModule(theme: .mainContent) {
                            
                            LazyVGrid(columns: [.desktop: [1, 1]]) {
                                SectionCard(
                                    title: "Profile",
                                    subtitle: "Personal details, password, and your communication preferences.",
                                    href: serverRouter.url(for: .account(.settings(.profile))).absoluteString,
                                    icon: .init(icon: "user")
                                )
                            }
                            .linkColor(.coenttbPrimaryColor)
                            
                        }
                        title: {
                            Header(4) {
                                "Manage billing"
                            }
                            .padding(bottom: 1.5.rem)
                            
                        }
                    },
                    mobileHeader: {
                        CoenttbNavigationBar()
                    }
                )
            },
            footer: { HTMLEmpty() }
        )
    case .profile:
        @Dependency(\.uuid) var uuid
        @Dependency(\.currentUser) var currentUser
        
        guard
            let currentUser,
            currentUser.authenticated == true
        else { throw Abort(.internalServerError, reason: "Must be logged in to access profile.") }
        
        return Coenttb.DefaultHTMLDocument(
            scripts: {
                fontAwesomeScript
            },
            navigationBar: { HTMLEmpty() },
            body: {
                StripeContainer(
                    sidebar: .init(
                        background: .coenttbAccentColor,
                        content: {
                            PageModule(theme: .sidebarContent) {
                                HTMLEmpty()
                            } title: {
                                CoenttbNavigationBar.CoenttbLogo()
                                    .height(100.percent)
                                
                                Header(3) {
                                    Link(
                                        destination: .account(.settings(.index)),
                                        String.settings.capitalizingFirstLetter().description
                                    )
                                    .linkUnderline(.none)
                                }
                                .textAlign(.left)
                            }
                        }
                    ),
                    main: {
                        PageModule(theme: .mainContent) {
                            VStack {
                                
                                NameChangeForm()
                                    .width(100.percent)
                                    .maxWidth(20.rem, media: .desktop)
                                    .maxWidth(24.rem, media: .mobile)
                                
                                EmailChangeRequestButton()
                                
                                PasswordChangeRequestButton()
                                
                                Button {
                                    String.logout.capitalizingFirstLetter()
                                }
                                .color(.primary)
                                .href(serverRouter.url(for: .account(.logout)).absoluteString)
                                
                            }
                        }
                        title: {
                            Header(4) {
                                "Identity"
                            }
                            .padding(bottom: 1.5.rem)
                            
                        }
                    },
                    mobileHeader: {
                        CoenttbNavigationBar()
                    }
                )
            },
            footer: { HTMLEmpty() }
        )
    }
}

public struct PasswordChangeRequestButton: HTML {
    @Dependency(\.serverRouter) var serverRouter
    
    public var body: some HTML {
        form {
            Button(
                tag: a
            ) {
                String.change_your_password.capitalizingFirstLetter()
            }
            .color(.primary)
            .href(serverRouter.url(for: .account(.password(.change(.request)))).absoluteString)
        }
    }
}

public struct EmailChangeRequestButton: HTML {
    @Dependency(\.serverRouter) var serverRouter
    @Dependency(\.currentUser) var currentUser
    
    public var body: some HTML {
        HStack {
            Input.default(CoenttbWebAccount.API.Verify.CodingKeys.email)
                .type(.email)
                .placeholder("Email")
                .value(currentUser?.email?.rawValue ?? "")
                .disabled(true)
            
            Button(
                tag: a,
                style: .secondary,
                icon: {
                    span { FontAwesomeIcon(icon: "pencil") }
                        .color(.secondary)
                        .fontWeight(.medium)
                },
                label: {
                    HTMLEmpty()
                }
            )
            .width(50.px)
            .href(serverRouter.url(for: .account(.emailChange(.request))).absoluteString)
        }
    }
}

public struct NameChangeForm: HTML {
    @Dependency(\.serverRouter) var serverRouter
    @Dependency(\.currentUser) var currentUser
    
    let form_identity_id: String = "form_identity_id-name-change-form"
    
    public var body: some HTML {
        form {
            VStack {
                Input.default(CoenttbWebAccount.API.Update.CodingKeys.name)
                    .type(.text)
                    .placeholder("Name")
                    .value(currentUser?.name ?? "")
            }
        }
        .id(form_identity_id)
        .method(.post)
        .action(serverRouter.url(for: .api(.v1(.account(.update(.init()))))).absoluteString)
        
        LiveInputScript(
            formID: form_identity_id,
            inputID: CoenttbWebAccount.API.Update.CodingKeys.name.rawValue
        )
    }
}
