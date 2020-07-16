//
//  Settings.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-07-16.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct Settings {
    
    // First Launch Checks
    static let hasLaunchedBefore = Defaults.bool(forKey: Keys.hasLaunchedBefore)
    static let hasLaunchedUpdateBefore = Defaults.bool(forKey: Keys.hasLaunchedUpdate)
    
    // Homepage Values
    static let homepageURL = Defaults.url(forKey: Keys.homepageURL)
    static let homepageString = Defaults.string(forKey: Keys.homepageString)
    
    
    /// Set default values for UserDefaults on first launch
    static func setDefaults() {
        Settings.save(Browser.defaultHome!, forKey: Keys.homepageURL)
        Settings.save(defaultHomeString, forKey: Keys.homepageString)
    }
    
    // Homepage
    static let defaultHomeString = "https://www.google.com/"
    static func getHomepage() -> String {
        if let homepage = homepageString {
            return homepage
        } else {
            return defaultHomeString
        }
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
