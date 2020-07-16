//
//  Browser.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-07-14.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct Browser {
    
    // MARK: Browser Properties
    static let name = "WiBlaze"
    static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    static let defaultHome = URL(string: "https://www.google.com/")     // Default Homepage
    
    // UserAgents
    static func getUserAgent() -> String {
        if Device.isPhone() { return phoneUserAgent }
        else { return padUserAgent }
    }
    static let phoneUserAgent  = "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1"
    static let padUserAgent    = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.1 Safari/605.1.15"
    
}

