//
//  Query.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-07-15.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct Query {
    
    static var isSearchTerm = false
    
    /// Determines if `query` is a URL or search term
    static func isURL(_ query: String) -> Bool {
        if query.contains(".") || query.contains("www") || query.contains("http") {
            return true
        }
        return false
    }
    /// Adds HTTPS to query if not already present
    static func addHTTP(_ query: String) -> URL {
        if query.contains("http://") || query.contains("https://") {
            return URL(string: query)!
        } else {
            return URL(string: "https://\(query)")!
        }
    }
    
    /// Takes a search query and returns a loadable URL
    static func getSearchableURL(_ query: String) -> URL {
        let searchBase = "https://www.google.com/search?&q="
        let searchTerm = query.replacingOccurrences(of: " ", with: "%20")
        return URL(string: "\(searchBase)\(searchTerm)") ?? URL(string: searchBase)!
    }
    
    static func getLoadable(_ query: String) -> URL {
        isSearchTerm = !isURL(query)                        // Check if query is URL
        
        if isSearchTerm {
            return getSearchableURL(query)
        } else {
            return addHTTP(query)
        }
    }
    
}

