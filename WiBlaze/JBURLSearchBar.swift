//
//  JBURLSearchBar.swift
//  WiBlaze
//
//  Created by Justin Bush on 2017-04-27.
//  Copyright © 2017 Justin Bush. All rights reserved.
//

import UIKit
import Foundation

class JBURLSearchBar: UITextField {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // Checks if URL passes validity test, returns valid URL
    func URLCheck(input: String) -> URL {
        
        print("Requested URL:", input)
        var formattedURL: String = "about:blank"
        
        // URL is empty
        if input.isEmpty {
            print("URL is empty")
        }
        
        // URL contains http:// and .ext
        else if input.range(of:"(?<=://)[^.]+(?=.?)", options:.regularExpression) != nil {
            print("URL is valid")
            formattedURL = input
        }
            
        // URL contains www. and .ext
        else if input.range(of:"(?<=www.)[^.]+(?=.?)", options:.regularExpression) != nil {
            print("URL is valid")
            formattedURL = input
        }
            
        // URL contains .ext, add http://
        else if input.range(of:"(?<=)[^.]+(?=.?)", options:.regularExpression) != nil {
            print("URL is valid, but needs prefix")
            formattedURL = appendURLPrefix(stringToAppend: input)
        }
            
        // URL is a search query
        else {
            formattedURL = stringToSearch(searchString: input)
            print(input, "is a search query")
            
        }
        
        return stringToURL(urlString: formattedURL)
    }
    
    // Converts String to URL
    func stringToURL(urlString: String) -> URL {
        
        let urlObj = NSURL(string: urlString as String)!
        return urlObj as URL
        
    }
    
    // Appends URL Prefix Scheme
    func appendURLPrefix(stringToAppend: String) -> String {
        
        let prefixString: String = "http://" + stringToAppend
        return prefixString
        
    }
    
    // Convert String to Search Query
    func stringToSearch(searchString: String) -> String {
        
        // Add Google prefix
        // Alternatively, take in a prefix for custom search result using bool for if there is another, or default (Google)
        let googleScheme = "https://www.google.com/search?q="
        let searchURL = googleScheme + searchString
        return searchURL
    }

}
