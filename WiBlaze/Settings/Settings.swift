//
//  Settings.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-07-16.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

// App Settings (ie. Dark Mode)
struct Settings {
    
    static let darkMode = Defaults.bool(forKey: Keys.darkMode)
    
    
    
    
    /// Set default values for UserDefaults on first launch
    static func setDefaults() {
        // Settings.save(true, forKey: Key.showToolbarKey)
    }
    
    /**
     Quick save value to `UserDefaults` with corresponding `Keys` value
     
     - Parameters:
        - value: variable to save to `UserDefaults`
        - forKey: corresponding value in `Keys` database
     */
    static func save(_ value: Any, forKey: String) {
        DefaultsManager.save(value, forKey: forKey)
    }
    
}
