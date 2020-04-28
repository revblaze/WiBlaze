//
//  Settings.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-04-27.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import UIKit
import Foundation

let Defaults = UserDefaults.standard

struct Settings {
    
    //static let userAgent =
    
    static func userAgent() -> String {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return "Mozilla/5.0 (iPhone; CPU iPhone OS 13_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Mobile/15E148 Safari/604.1"
        } else {
            return "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Safari/605.1.15"
        }
    }
    
    static let homepage = Defaults.string(forKey: Key.homepage)             // Homepage URL
    static let searchEngine = Defaults.string(forKey: Key.searchEngine)     // Preferred Search Engine
    
    static let restoreLastSession = Defaults.bool(forKey: Key.lastSession)
    static let lastSessionURL = Defaults.string(forKey: Key.lastSessionURL)
    
    
    struct Key {
        static let homepage = "Homepage"
        static let searchEngine = "SearchEngine"
        static let lastSession = "RestoreLastSession"
        static let lastSessionURL = "LastSessionURL"
    }
    
    static func save(_ value: Any, forKey: String) {
        Keys.saveToDefaults(value, forKey: forKey)
        Defaults.synchronize()
    }
    
    static func setDefault() {
        Settings.save("https://google.com", forKey: Key.homepage)
    }
    
}

enum SearchEngine: CaseIterable {
    
    case google
    case bing
    case yahoo
    case duckduckgo
    case baido
    case yandex
    
    var prefixURL: String {
        switch self {
        case .google: return "https://www.google.com/search?q="
        case .bing: return "https://bing"
        case .yahoo: return "https://yahoo"
        case .duckduckgo: return "https://duckduckgo"
        case .baido: return "https://baido"
        case .yandex: return "https://yandex.ru"
        }
    }
    
}
