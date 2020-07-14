//
//  DeviceManager.swift
//  UWeb
//
//  Created by Justin Bush on 2020-05-13.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import UIKit

struct Device {
    
    static func isPhone() -> Bool {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
            return true
        case .pad:
            // It's an iPad (or macOS Catalyst)
            return false
        case .unspecified:
            // Uh, oh! What could it be?
            return false
        case .tv:
            return false
            
        case .carPlay:
            return false
            
        @unknown default:
            return false
            
        }
    }
    
    static func isPortrait() -> Bool {
        
        if UIDevice.current.orientation.isLandscape {
            return false
        }
        
        return true
        
        /*
        switch UIDevice.current.orientation {
            
        case .portrait:
            return true
        case .
            
        }
        */
        
    }
    
}
