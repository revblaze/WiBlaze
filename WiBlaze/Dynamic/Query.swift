//
//  Query.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-04-28.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct Query {
    
    static var isSearch = false             // Search query flag
    // Helper Variables
    static let aboutBlank = URL(string: "about:blank")!
    static let urlSyntax = [".", "http", "www", ":", "/"]
    
    /// Checks if input `query` has URL `properties` or is a search query
    static func validURL(_ query: String) -> Bool {
        for syntax in urlSyntax {                       // Check if Query contains URL properties
            if query.contains(syntax) { return true }
        }
        return false
    }
    
    /// Takes  user input as `String`, determines if input is URL or search query, and returns appropriate URL
    static func toURL(_ query: String) -> URL {
        Active.query = query        // Set Active query value
        let url = query.replacingOccurrences(of: " ", with: "%20")
        if validURL(url) {                      // If query is a valid URL
            isSearch = false                    // Query is valid URL, not search
            Active.url = needsHTTPS(query)      // Check if URL needs HTTPS
            return Active.url!
        } else {                                // Else if query is Search term
            isSearch = true                     // Query is search, not valid URL
            let searchString = "https://www.google.com/search?q=\(url)"
            return searchString.toURL()
        }
    }
    
    static func needsHTTPS(_ query: String) -> URL {
        var urlString = "about:blank"
        if !query.contains("//") { urlString = "https://\(query)" }
        else { urlString = query }
        
        Active.urlString = urlString
        if debug { print("needsHTML: \(urlString)") }
        
        return urlString.toURL()
            //return query.toURL()
    }
    
    static func updateSearch(_ query: String) -> Bool {
        if query.contains("google") && query.contains("search?q=") {
            isSearch = true
            return true
        } else {
            isSearch = false
            return false
        }
    }
    
    
    
}
