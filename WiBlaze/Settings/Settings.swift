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
    
    // NEW HOMEPAGE
    static let homeString = Defaults.string(forKey: Keys.homepageString)
    static let homeURL = URL(string: homeString!)
    
    // Restore Last Session URL
    static let restoreLastSession = Defaults.bool(forKey: Keys.restoreLastSession)
    static let lastSessionURL = Defaults.string(forKey: Keys.lastSessionURL)
    
    
    /// Set default values for UserDefaults on first launch
    static func setDefaults() {
        Settings.save(Default.homeURL!, forKey: Keys.homepageURL)
        Settings.save(Default.homeString, forKey: Keys.homepageString)
        Settings.save(true, forKey: Keys.restoreLastSession)
    }
    
    // Launch URL
    /// Returns launch `URL` as `String`, depending on Restore Last Session and Custom Homepage
    static func getLaunchURL() -> String {
        return getLastSessionURL()
    }
    
    // Homepage
    /// Return custom homepage URL or default URL as `String`
    static func getHomepage() -> String {
        if let homepage = homeString { return homepage }
        else { return Default.homeString }
    }
    // Restore Last Session
    /// Return URL of last session if enabled or homepage if disabled
    static func getLastSessionURL() -> String {
        if Settings.restoreLastSession {
            if let url = Settings.lastSessionURL {
                return url
            } else {
                return homeString!
            }
        } else {
            return getHomepage()
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
