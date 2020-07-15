//
//  Pretty.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-07-15.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct Pretty {
    
    /**
     Takes a raw `URL` and returns a pretty `URL` as `String`
     # Usage
            let site = URL(string: "https://site.com/...")
            Pretty.url(site)
            > "site.com"
     */
    static func url(_ url: URL) -> String {
        return toBase(url)
    }
    
    static func toBase(_ url: URL) -> String {
        var baseString = url.host
        baseString = baseString?.replacingOccurrences(of: "www.", with: "")
        return baseString ?? ""
    }
    
}
