//
//  Settings.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-05-05.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct Settings {
    
    // CUSTOM HOMEPAGE
    static let homepageURL = defaults.url(forKey: Key.homepage)     // Homepage: URL Value
    static let homepageON = defaults.bool(forKey: Key.homepageON)   // Homepage: ON/OFF
    
    // RESTORE SESSION
    static let restoreSessionURL = defaults.url(forKey: Key.restoreSession)     // Restore: URL Value
    static let restoreSessionON = defaults.bool(forKey: Key.restoreSessionON)   // Restore: ON/OFF
    
    
    
    
    struct Key {
        static let homepage = "Homepage"        // Key Val: Homepage URL
        static let homepageON = "HomepageON"    // Key Set: Homepage ON/OFF
        static let restoreSession = "RestoreSession"        // Key Val: Restore Session URL
        static let restoreSessionON = "RestoreSessionON"    // Key Set: Restore Session ON/OFF
    }
    
}
