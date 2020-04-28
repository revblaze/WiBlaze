//
//  Keys.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-04-27.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

struct Keys {
    
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
    
    static func saveToDefaults(_ value: Any, forKey: String) {
        if allowedType(value) {
            if debug { print("Setting Default: \(value), forKey: \(forKey)") }
            Defaults.set(value, forKey: forKey)
        } else {
            if debug { print("Error: invalid Default type\nUnable to set Default: \(value), forKey: \(forKey)") }
        }
    }
    
}

