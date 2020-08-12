//
//  Query.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-07-15.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct Query {
    
    static var text = ""
    static var isSearchTerm = true
    static let urlSyntax = [".", "http", "www", ":", "/"]
    
    /// Determines if `query` is a URL or search term
    static func isURL(_ query: String) -> Bool {
        print("Query.isURL query: \(query)")
        /*
        for syntax in urlSyntax {                       // Check if Query contains URL properties
            print("Does \(query) contain \(syntax)")
            if query.contains(syntax) { return true }
        }
        */
        if query.contains("http") || query.contains("www") || query.contains(".") {
            // Detect for search term "http"
            if query.contains("http ") || query.contains("https ") {
                return false
            } else {
                return true
            }
        }
        return false
    }
    /// Adds HTTPS to query if not already present
    static func addHTTP(_ query: String) -> URL {
        if query.contains("http://") || query.contains("https://") {
            return URL(string: query)!
        } else {
            let url = "https://\(query)"
            return URL(string: url)!
        }
    }
    
    /// Takes a search query and returns a loadable URL
    static func getSearchableURL(_ query: String) -> URL {
        let searchBase = "https://www.google.com/search?&q="
        let searchTerm = query.replacingOccurrences(of: " ", with: "%20")
        return URL(string: "\(searchBase)\(searchTerm)") ?? URL(string: searchBase)!
    }
    /**
     Grabs input query `String` and returns a loadable `URL` for WebView, while setting `Live` variables
     - parameters:
        - query: Input text to query from TextField
     # Start
     1. Determines if `query` is a URL or search term
     2. Sets `Query.text` = `query`
     3. Sets `Query.isSearchTerm` to `true` or `false`
     # Case: Search Term
     1. Sets `Live.searchTerm` =  `query`
     2. Gets `loadableURL` for `query` search term
     3. Sets `Live.fullURL` = `loadableURL`
     # Case: URL
     1. Gets `loadableURL` for `query` address and prepends `https://` if needed
     2. Sets `Live.prettyURL` = `Pretty.url(loadableURL)`
     3. Sets `Live.fullURL` = `loadableURL`
     
     # Usage
            let query = textField.text
            let url = Query.getLoadable(query)
            webView.load(url)
     
            // Set TextField
            textField.text = Pretty.url
     
     - returns: `loadableURL` (a `URL` for loading in WebView)
     */
    static func getLoadable(_ query: String) -> URL {
        text = query
        isSearchTerm = !isURL(query)                         // Check if query is URL
        print("isSearchTerm: \(isSearchTerm)")
        
        if isSearchTerm {
            let loadableURL = getSearchableURL(query)
            Live.set(query, forType: .search)                       // Set Live.searchTerm
            Live.set(loadableURL.absoluteString, forType: .full)  // Set Live.fullURL
            return loadableURL //getSearchableURL(query)
        } else {
            let loadableURL = addHTTP(query)
            let prettyURL = Pretty.url(loadableURL)
            Live.set(prettyURL, forType: .pretty)
            Live.set(loadableURL.absoluteString, forType: .full)
            return loadableURL //addHTTP(query)
        }
        
    }
    
    static func updateURL(_ url: String) {
        Live.set(url, forType: .full)
        //isSearchTerm = !isURL(url)
        //if url.contains("https://www.google.com/search?&q") {
        if url.contains("https://www.google.") {
            isSearchTerm = true
        } else {
            isSearchTerm = false
        }
    }
    
}

