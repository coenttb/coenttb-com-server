//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 30/08/2024.
//

import Coenttb_Server
import Coenttb_Web
import EnvironmentVariables
import GoogleAnalytics
import Hotjar
import Mailgun
import Postgres
// import Coenttb_Stripe

extension EnvVars {
    package var postgres: Postgres.Client.EnvVars {
        .init(
            databaseUrl: self["DATABASE_URL"]!
        )
    }

//    package var mailgun: Mailgun.EnvVars? {
//        guard
//            let baseURL = self.url("MAILGUN_BASE_URL"),
//            let apiKey = self["MAILGUN_PRIVATE_API_KEY"],
//            let domain = self["MAILGUN_DOMAIN"]
//        else {
//            return nil
//        }
//
//        return .init(
//            baseUrl: baseURL,
//            apiKey: .init(rawValue: apiKey),
//            domain: try! .init(domain)
//        )
//    }

//    package var stripe: Coenttb_Stripe.Client.EnvVars? {
//        guard
//            let endpointSecret = self["STRIPE_ENDPOINT_SECRET"],
//            let publishableKey = self["STRIPE_PUBLISHABLE_KEY"],
//            let secretKey = self["STRIPE_SECRET_KEY"]
//        else {
//            return nil
//        }
//
//        return .init(
//            endpointSecret: endpointSecret,
//            publishableKey: publishableKey,
//            secretKey: secretKey
//        )
//    }

    package var googleAnalytics: GoogleAnalytics.Client.EnvVars? {
        guard let id = self["GOOGLE_ANALYTICS_ID"]
        else { return nil }

        return .init(
            id: id
        )
    }

    package var hotjarAnalytics: Hotjar.Client.EnvVars? {
        guard let id = self["HOTJAR_ANALYTICS_ID"]
        else { return nil }

        return .init(
            id: id
        )
    }

}

extension EnvVars {
    package var mailgunCompanyEmail: EmailAddress? {
        self["MAILGUN_COMPANY_EMAIL"].flatMap(EmailAddress.init(rawValue:))
    }
}

extension EnvVars {
    package var jwtPublicKey: String? {
        self["JWT_PUBLIC_KEY"]!
    }
}

extension EnvVars {
    package var demoName: String? {
        self["DEMO_NAME"]
    }

    package var demoEmail: EmailAddress? {
        self["DEMO_EMAIL"].flatMap(EmailAddress.init(rawValue:))
    }

    package var demoPassword: String? {
        self["DEMO_PASSWORD"]
    }

    package var demoNewsletterEmail: EmailAddress? {
        self["DEMO_NEWSLETTER_EMAIL"].flatMap(EmailAddress.init(rawValue:))
    }

    package var demoStripeCustomerId: String? {
        self["DEMO_STRIPE_CUSTOMER_ID"]
    }

    package var monthlyBlogSubscriptionPriceId: String? {
        self["MONTHLY_BLOG_SUBSCRIPTION_PRICE_ID"]
    }

    package var monthlyBlogSubscriptionPriceLookupKey: String? {
        self["MONTHLY_BLOG_SUBSCRIPTION_PRICE_LOOKUP_KEY"]
    }

    package var newsletterAddress: EmailAddress? {
        self["NEWSLETTER_ADDRESS"].flatMap(EmailAddress.init(rawValue:))
    }

    package var companyName: String? {
        self["COMPANY_NAME"]
    }

    package var companyInfoEmailAddress: EmailAddress? {
        self["COMPANY_INFO_EMAIL_ADDRESS"].flatMap(EmailAddress.init(rawValue:))
    }

    package var companyXComHandle: String? {
        self["COMPANY_X_COM_HANDLE"]
    }

    package var companyGitHubHandle: String? {
        self["COMPANY_GITHUB_HANDLE"]
    }

    package var companyLinkedInHandle: String? {
        self["COMPANY_LINKEDIN_HANDLE"]
    }

    package var sessionCookieName: String? {
        self["SESSION_COOKIE_NAME"]
    }
}
