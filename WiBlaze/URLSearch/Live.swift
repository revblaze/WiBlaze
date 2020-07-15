//
//  Live.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-07-15.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct Live {
    
    static var searchTerm = ""      // ie. "hello world"
    static var prettyURL = ""       // ie. "google.com"
    static var fullURL = ""         // ie. https://google.com/...
    
    static func set(_ query: String, forType: LiveType) {
        //forType.setLive = query
        
        switch forType {
        case .search: searchTerm = query
        case .pretty: prettyURL = query
        case .full: fullURL = query
        }
    }
    
}

enum LiveType {
    
    case search
    case pretty
    case full
    
    var setLive: String {
        switch self {
        case .search: return Live.searchTerm
        case .pretty: return Live.prettyURL
        case .full:   return Live.fullURL
        }
    }
    
}
