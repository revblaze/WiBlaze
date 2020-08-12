//
//  DefaultsManager.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-07-16.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

let Defaults = UserDefaults.standard

struct DefaultsManager {
    
    static func allowedType(_ object: Any) -> Bool {
        switch object {
        case is Bool: return true
        case is String: return true
        case is URL: return true
        case is Int: return true
        case is Double: return true
        case is Float: return true
        default: return false
        }
    }
    
    static func save(_ value: Any, forKey: String) {
        if allowedType(value) {
            Debug.log("Setting Default: \(value), forKey: \(forKey)")
            Defaults.set(value, forKey: forKey)
        } else {
            Debug.log("Error: invalid Default type\nUnable to set Default: \(value), forKey: \(forKey)")
        }
    }
    
}
