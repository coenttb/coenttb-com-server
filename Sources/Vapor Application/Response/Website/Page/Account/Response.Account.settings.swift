//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/09/2024.
//

import Coenttb_Vapor
import Server_Application
import Coenttb_Com_Shared
import Coenttb_Com_Router
import Coenttb_Identity_Consumer


func settings(
    settings: WebsitePage.Account.Settings,
    create_customer_portal_session_return_url: URL
) async throws -> AsyncResponseEncodable {
    @Dependency(\.coenttb.website.router) var serverRouter

    switch settings {
    case .index:
        return Server_Application.DefaultHTMLDocument(
            scripts: {
                fontAwesomeScript
            },
            navigationBar: { HTMLEmpty() },
            body: {
                StripeContainer(
                    sidebar: .init(
                        background: .branding.accent,
                        content: {
                            PageModule(theme: .sidebarContent) {
                                HTMLEmpty()
                            } title: {
                                CoenttbNavigationBar.CoenttbLogo()
                                    .height(.percent(100))

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
                                    title: String.profile.capitalizingFirstLetter().description,
                                    subtitle: TranslatedString(
                                        dutch: "Persoonsgegevens, wachtwoord en jouw communicatievoorkeuren",
                                        english: "Personal details, password, and your communication preferences"
                                    ).period.description,
                                    href: serverRouter.url(for: .account(.settings(.profile))).absoluteString,
                                    icon: .init(icon: "user")
                                )
                            }
                            .linkColor(.text.link)

                        }
                        title: {
                            Header(4) {
                                String.settings.capitalizingFirstLetter().description
                            }
                            .padding(bottom: .rem(1.5))

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

        return Server_Application.DefaultHTMLDocument(
            scripts: {
                fontAwesomeScript
            },
            navigationBar: { HTMLEmpty() },
            body: {
                StripeContainer(
                    sidebar: .init(
                        background: .branding.accent,
                        content: {
                            PageModule(theme: .sidebarContent) {
                                HTMLEmpty()
                            } title: {
                                CoenttbNavigationBar.CoenttbLogo()
                                    .height(.percent(100))

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
                                Header(5) {
                                    String.identity.capitalizingFirstLetter()
                                }

//                                NameChangeForm()
//                                    .width(.percent(100))
//                                    .maxWidth(.rem(20), media: .desktop)
//                                    .maxWidth(.rem(24), media: .mobile)

                                EmailChangeRequestButton()

                                PasswordChangeRequestButton()

                                Button {
                                    String.logout.capitalizingFirstLetter()
                                }
                                .color(.text.primary)
                                .href(serverRouter.url(for: .identity(.logout)).absoluteString)

                            }
                        }
                        title: {
                            Header(4) {
                                String.profile.capitalizingFirstLetter()
                            }
                            .padding(bottom: .rem(1.5))

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
    @Dependency(\.coenttb.website.router) var serverRouter

    public var body: some HTML {
        form {
            Link(href: .init(serverRouter.url(for: .identity(.password(.change(.request)))).absoluteString)) {
                String.change_your_password.capitalizingFirstLetter()
            }
            .color(.text.primary)
            
//            Button(
//                tag: a
//            ) {
//                String.change_your_password.capitalizingFirstLetter()
//            }
//            .color(.text.primary)
//            .href(serverRouter.url(for: .identity(.password(.change(.request)))).absoluteString)
        }
    }
}

public struct EmailChangeRequestButton: HTML {
    @Dependency(\.coenttb.website.router) var serverRouter
    @Dependency(\.currentUser) var currentUser

    public var body: some HTML {
        HStack {
            Input(
                codingKey: Identity.Email.Change.Request.CodingKeys.newEmail,
                disabled: true,
                type: .email(
                    .init(
                        value: .init(currentUser?.email?.rawValue ?? ""),
                        placeholder: "Email"
                    )
                )
            )
//            Input.default(Identity.Email.Change.Request.CodingKeys.newEmail)
//                .type(.email)
//                .placeholder("Email")
//                .value(currentUser?.email?.rawValue ?? "")
//                .disabled(true)

            
            Link(href: .init(serverRouter.url(for: .identity(.email(.change(.request)))).absoluteString)) {
                Label {
                    HTMLEmpty()
                } title: {
                    span { FontAwesomeIcon(icon: "pencil") }
                        .color(.text.secondary)
                        .fontWeight(.medium)
                }

            }
            .width(.px(50))
//            Button(

//                tag: a,
//                style: .secondary,
//                icon: {
                    span { FontAwesomeIcon(icon: "pencil") }
                        .color(.text.secondary)
                        .fontWeight(.medium)
//                },
//                label: {
//                    HTMLEmpty()
//                }
//            )
//            .width(50.px)
//            .href(serverRouter.url(for: .identity(.email(.change(.request)))).absoluteString)
        }
    }
}

//public struct NameChangeForm: HTML {
//    @Dependency(\.coenttb.website.router) var serverRouter
//    @Dependency(\.currentUser) var currentUser
//
//    let form_identity_id: String = "form_identity_id-name-change-form"
//
//    public var body: some HTML {
//        form {
//            VStack {
//                Input.default(Coenttb_Identity.API.Update.CodingKeys.name)
//                    .type(.text)
//                    .placeholder("Name")
//                    .value(currentUser?.name ?? "")
//            }
//        }
//        .id(form_identity_id)
//        .method(.post)
////        .action(serverRouter.url(for: .api(.identity(.update(.init())))).absoluteString)
//
//        LiveInputScript(
//            formID: form_identity_id,
//            inputID: Coenttb_Identity.API.Update.CodingKeys.name.rawValue
//        )
//    }
//}
