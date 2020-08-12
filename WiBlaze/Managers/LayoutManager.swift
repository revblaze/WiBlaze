//
//  LayoutManager.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-08-12.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import UIKit

struct LayoutManager {
    
    static func needsFullScreen(_ domain: String) -> Bool {
        for site in Domains.requireFullScreen {
            if site.contains(domain) { return true }
            else { return false }
        }
        return false
    }
    
}

struct Site {
    
    static func needsFullScreen(_ domain: String) -> Bool {
        for site in Domains.requireFullScreen {
            if domain.contains(site) { return true }
        }
        return false
    }
    
}

struct Domains {
    
    static let requireFullScreen = ["youtube.com"]
    
}
