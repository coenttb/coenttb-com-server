//
//  File.swift
//  coenttb-com-server
//
//  Created by Coen ten Thije Boonkkamp on 23/12/2024.
//

import Foundation
import Testing
import Coenttb_Server
import DependenciesTestSupport
import Coenttb_Blog
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
        
        let html = String(head)
        
        #expect(html.contains { "viewport" })
    }
    
    @Test("Document should handle multiple languages")
    func testLanguageSupport() {
        withDependencies {
            $0.languages = [.dutch, .english]
        } operation: {
            let doc = DefaultHTMLDocument { HTMLEmpty() }
            let html = String(doc)
            
            #expect(html.contains(#"lang="en""#))
            #expect(html.contains(#"hreflang="nl""#))
        }
    }
}
