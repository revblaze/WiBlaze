//
//  URLHelper.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-04-28.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct URLHelper {
    
    static func isHTTPS(_ url: String) -> Bool {
        if url.contains("https://") { return true }
        return false
    }
    
}
