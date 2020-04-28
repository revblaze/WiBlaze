//
//  Query.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-04-27.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct Query {
    
    //static var url = ""
    static var text = ""                    // User-entered query
    static var title = ""                   // Page Title via WebKit
    static var isSearch = false             // Search query flag
    static let aboutBlank = URL(string: "about:blank")!
    
    static let urlSyntax = [".", "http", "www", ":", "/"] // "://", "/"
    /// Checks if input `query` has URL `properties` or is a search query
    static func isURL(_ query: String) -> Bool {
        for syntax in urlSyntax {
            if query.contains(syntax) { return true }
            else { isSearch = true }
        }
        return false
    }
    
    static func needsHTTPS(_ query: String) -> URL {
        if !query.contains("//") { return URL(string: "https://\(query)") ?? aboutBlank }
        else { return URL(string: query) ?? aboutBlank }
    }
    /// Takes  user input as `String`, determines if input is URL or search query, and returns appropriate URL
    static func toURL(_ query: String) -> URL {
        text = query                // Set User input query as Query.text
        let url = query.replacingOccurrences(of: " ", with: "%20")
        if isURL(url) {
            return needsHTTPS(url)
        } else {
            isSearch = true
            return URL(string: "https://www.google.com/search?q=\(url)") ?? aboutBlank
            // url = SearchEngine.(google).prefixURL
            // return URL(string: url) ?? aboutBlank
        }
    }
    
    
}

