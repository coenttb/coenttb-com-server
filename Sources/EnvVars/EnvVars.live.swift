//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 30/08/2024.
//

@_exported import CoenttbEnvVars
import Dependencies
import Foundation
import ServerModels
import Mailgun
import GitHub
import Postgres
import Hotjar
import GoogleAnalytics
import CoenttbWebStripe

extension EnvVars: @retroactive DependencyKey {
    public static var liveValue: Self {
        let localDevelopment: URL? = {
#if DEBUG
            return URL.projectRoot.appendingPathComponent(".env.development")
#else
            return nil
#endif
        }()
        return CoenttbEnvVars.EnvVars.live(
            localDevelopment: localDevelopment
        )
    }
}

extension EnvVars {
    public var postgres: Postgres.Client.EnvVars {
        .init(
            databaseUrl: self["DATABASE_URL"]!
        )
    }
    
    public var mailgun: Mailgun.Client.EnvVars? {
        guard
            let baseUrl = self["MAILGUN_BASE_URL"],
            let apiKey = self["MAILGUN_PRIVATE_API_KEY"],
            let domain = self["MAILGUN_DOMAIN"]
        else {
            return nil
        }
        
        return .init(
            baseUrl: .init(baseUrl),
            apiKey: .init(apiKey),
            domain: .init(domain)
        )
    }
    
    public var stripe: CoenttbWebStripe.Client.EnvVars? {
        guard
            let endpointSecret = self["STRIPE_ENDPOINT_SECRET"],
            let publishableKey = self["STRIPE_PUBLISHABLE_KEY"],
            let secretKey = self["STRIPE_SECRET_KEY"]
        else {
            return nil
        }
        
        return .init(
            endpointSecret: endpointSecret,
            publishableKey: publishableKey,
            secretKey: secretKey
        )
    }
    
    public var gitHub: GitHub.Client.EnvVars? {
        
        guard
            let clientId = self["GITHUB_CLIENT_ID"],
            let clientSecret = self["GITHUB_CLIENT_SECRET"]
        else {
            return nil
        }
        
        return .init(
            clientId: .init(clientId),
            clientSecret: .init(clientSecret)
        )
    }
    
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
    public var mailgunCompanyEmail: String? {
        self["MAILGUN_COMPANY_EMAIL"]
    }
}
extension EnvVars {
    public var demoName: String? {
        self["DEMO_NAME"]
    }
    
    public var demoEmail: String? {
        self["DEMO_EMAIL"]
    }
    
    public var demoPassword: String? {
        self["DEMO_PASSWORD"]
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
    
    public var companyName: String? {
        self["COMPANY_NAME"]
    }
    
    public var companyInfoEmailAddress: String? {
        self["COMPANY_INFO_EMAIL_ADDRESS"]
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
