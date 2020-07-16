//
//  User.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-07-16.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

// User Activity and Status (ie. hasLoggedIn, hasLaunchedBefore)
struct User {
    
    /*
    static let id = Defaults.string(forKey: Keys.username)
    static let password = Defaults.string(forKey: Keys.password)
    
    static let isLoggedIn = Defaults.bool(forKey: Keys.hasLoggedIn)
    */
 
    
    
    
    /// Set default values for UserDefaults on first launch
    static func setDefaults() {
        // User.save(true, forKey: Key.showToolbarKey) 
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
