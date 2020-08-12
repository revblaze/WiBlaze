//
//  Alerts.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-08-12.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import Foundation

enum Alerts: CaseIterable {
    // Settings
    case restore
    case homepage
    case restoreLast
    case setHomeInfo
    
    case customHome
    case setHome
    
    case other
    
    var title: String {
        switch self {
        case .restore:      return "Restore Default Settings"
        case .homepage:     return "Custom Homepage"
        case .restoreLast:  return "Restore Last Session"
        case .setHomeInfo:  return "Setting the Homepage"
        case .customHome:   return "Set Custom Homepage"
        case .setHome:      return "Homepage Saved"
        case .other:        return "Settings"
        }
    }
    
    var message: String {
        switch self {
        case .restore:      return "\nAre you sure you would like to restore WiBlaze to its default settings?\n\nThis will revert all changes to how they were when you first downloaded the app."
        case .homepage:     return "\nWiBlaze will now load your custom homepage on launch.\n\nLearn how to change your custom homepage by tapping ⓘ."
        case .restoreLast:  return "\nWiBlaze will now restore your last session on launch.\n\nCustom homepage has been turned off."
        case .setHomeInfo:  return "\nTo set a custom homepage, head back to the browser and navigate to the page you wish to set as home.\n\nFrom there, open the circle menu and tap on the red heart button.\n\nNote: Restore Last Session will need to be turned off to have WiBlaze load your homepage at launch." //"1. Navigate to the desired page\n2. Tap the menu icon in the top right corner\n3. Click on the red heart icon"
        case .customHome:   return "\nWould you like to set the following URL as your new homepage?\n\n\(Live.fullURL)"
        case .setHome:      return "\n\(Live.prettyURL) has been saved as your new homepage!\n\nWe've turned off Restore Last Session for you. You can turn it back on at any time in Preferences."
            
        case .other:        return "\nYour changes have been saved."
        }
    }
    
}

