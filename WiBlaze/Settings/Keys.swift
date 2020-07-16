//
//  Keys.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-07-16.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct Keys {
    
    // MARK: System Keys
    static let hasLaunchedBefore = "UserLaunchedBeforeKey"
    static let hasLaunchedUpdate = "UserLaunchedUpdate\(Browser.version!)"
    
    // MARK: Settings Keys
    
    // Homepage
    static let homepageURL = "HomepageKey"
    static let homepageString = "HomepageStringKey"
    // Restore Last Session
    static let restoreLastSession = "RestoreLastSession"
    static let lastSessionURL = "LastSessionURL"
    
}
