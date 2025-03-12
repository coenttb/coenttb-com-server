//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 30/08/2024.
//

import Coenttb_Server
import EnvironmentVariables
import GoogleAnalytics
import Hotjar
import Mailgun
import Postgres
//import Coenttb_Stripe


extension EnvVars {
    public var postgres: Postgres.Client.EnvVars {
        .init(
            databaseUrl: self["DATABASE_URL"]!
        )
    }

    public var mailgun: Mailgun.Client.EnvVars? {
        guard
            let baseURL = self.url("MAILGUN_BASE_URL"),
            let apiKey = self["MAILGUN_PRIVATE_API_KEY"],
            let domain = self["MAILGUN_DOMAIN"]
        else {
            return nil
        }

        return .init(
            baseUrl: baseURL,
            apiKey: .init(rawValue: apiKey),
            domain: try! .init(domain)
        )
    }

//    public var stripe: Coenttb_Stripe.Client.EnvVars? {
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

    public var googleAnalytics: GoogleAnalytics.Client.EnvVars? {
        guard let id = self["GOOGLE_ANALYTICS_ID"]
        else { return nil }

        return .init(
            id: id
        )
    }

    public var hotjarAnalytics: Hotjar.Client.EnvVars? {
        guard let id = self["HOTJAR_ANALYTICS_ID"]
        else { return nil }

        return .init(
            id: id
        )
    }
}

extension EnvVars {
    public var mailgunCompanyEmail: EmailAddress? {
        self["MAILGUN_COMPANY_EMAIL"].flatMap(EmailAddress.init(rawValue:))
    }
}
extension EnvVars {
    public var demoName: String? {
        self["DEMO_NAME"]
    }

    public var demoEmail: EmailAddress? {
        self["DEMO_EMAIL"].flatMap(EmailAddress.init(rawValue:))
    }

    public var demoPassword: String? {
        self["DEMO_PASSWORD"]
    }

    public var demoNewsletterEmail: EmailAddress? {
        self["DEMO_NEWSLETTER_EMAIL"].flatMap(EmailAddress.init(rawValue:))
    }

    public var demoStripeCustomerId: String? {
        self["DEMO_STRIPE_CUSTOMER_ID"]
    }

    public var monthlyBlogSubscriptionPriceId: String? {
        self["MONTHLY_BLOG_SUBSCRIPTION_PRICE_ID"]
    }

    public var monthlyBlogSubscriptionPriceLookupKey: String? {
        self["MONTHLY_BLOG_SUBSCRIPTION_PRICE_LOOKUP_KEY"]
    }
    
    public var newsletterAddress: EmailAddress? {
        self["NEWSLETTER_ADDRESS"].flatMap(EmailAddress.init(rawValue:))
    }

    public var companyName: String? {
        self["COMPANY_NAME"]
    }

    public var companyInfoEmailAddress: EmailAddress? {
        self["COMPANY_INFO_EMAIL_ADDRESS"].flatMap(EmailAddress.init(rawValue:))
    }

    public var companyXComHandle: String? {
        self["COMPANY_X_COM_HANDLE"]
    }

    public var companyGitHubHandle: String? {
        self["COMPANY_GITHUB_HANDLE"]
    }

    public var companyLinkedInHandle: String? {
        self["COMPANY_LINKEDIN_HANDLE"]
    }

    public var sessionCookieName: String? {
        self["SESSION_COOKIE_NAME"]
    }
}
