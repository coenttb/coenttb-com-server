//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 23/12/2024.
//

import Foundation
import Testing
import CoenttbWeb
import DependenciesTestSupport
import CoenttbBlog
@testable import Coenttb

@Suite("Blog Post Tests")
struct BlogPostTests {
    @Test("All cases should have valid index values")
    func testBlogPostIndices() {
        let posts = [Blog.Post].allCases
        
        for post in posts {
            #expect(post.index >= 0, "Post index should be non-negative")
            #expect(post.id.uuidString.isEmpty == false, "Post ID should be valid")
        }
    }
}

@Suite("Document Tests")
struct DocumentTests {
    @Test("HTML document should include required meta elements")
    func testHTMLDocumentStructure() {
        let doc = DefaultHTMLDocument { HTMLEmpty() }
        let head = doc.head
        
        // Check for required meta elements
        let html = String(head)
        
        #expect(html.contains { "viewport" })
    }
    
    @Test("Document should handle multiple languages")
    func testLanguageSupport() {
        withDependencies {
            $0.language = .dutch
        } operation: {
            let doc = DefaultHTMLDocument { HTMLEmpty() }
            let html = String(doc.body)
            
            #expect(html.contains("nl"))
        }
        
        withDependencies {
            $0.language = .english
        } operation: {
            let doc = DefaultHTMLDocument { HTMLEmpty() }
            let html = String(doc.body)
            
            #expect(html.contains("en"))
        }
    }
}
//
//@Suite("Internationalization Tests")
//struct InternationalizationTests {
//    @Test("One-liner should be translated correctly")
//    func testOneLinerTranslation() {
//        withDependencies {
//            $0.language = .dutch
//        } operation: {
//            let dutch = Coenttb.oneliner.description
//            #expect(dutch.contains("Rechten"))
//            #expect(dutch.contains("Code"))
//            #expect(dutch.contains("Startups"))
//        }
//        
//        withDependencies {
//            $0.language = .english
//        } operation: {
//            let english = Coenttb.oneliner.description
//            #expect(english.contains("Law"))
//            #expect(english.contains("Code"))
//            #expect(english.contains("Startups"))
//        }
//    }
//    
//    @Test("Website pages should have correct translations")
//    func testPageTranslations() {
//        let pages: [WebsitePage] = [
//            .home,
//            .blog(.index),
//            .privacy_statement,
//            .contact
//        ]
//        
//        for page in pages {
//            let title = page.title
//            #expect(title != nil, "Page \(page) should have a title")
//            
//            let description = page.description()
//            #expect(description != nil, "Page \(page) should have a description")
//        }
//    }
//}
//
//@Suite("Color Tests")
//struct ColorTests {
//    @Test("Brand colors should be correctly defined")
//    func testBrandColors() {
//        let accentColor = HTMLColor.coenttbAccentColor
//        let primaryColor = HTMLColor.coenttbPrimaryColor
//        let linkColor = HTMLColor.coenttbLinkColor
//        
//        #expect(accentColor == .green850)
//        #expect(primaryColor == .green550.withDarkColor(.green600))
//        #expect(linkColor == .orange600)
//    }
//}
//
//struct EmptyView: HTML {
//    var body: some HTML {
//        HTMLEmpty()
//    }
//}
