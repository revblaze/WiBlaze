//
//  Keys.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-07-16.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct Keys {
    
    // MARK: User Keys
    static let username = "UsernameKey"
    static let password = "PasswordKey"
    
    static let hasLoggedIn = "UserLoggedInKey"
    static let hasLaunchedBefore = "UserLaunchedBeforeKey"
    static let hasLaunchedUpdate = "UserLaunchedUpdate\(Client.version)"
    
    
    // MARK: Settings Keys
    static let darkMode = "DarkModeKey"
    
}
