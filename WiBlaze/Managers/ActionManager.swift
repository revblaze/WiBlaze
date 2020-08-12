//
//  ActionManager.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-08-12.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import UIKit

struct ActionManager {
    
    static func getAlert(_ title: String, enabled: Bool) -> Alerts {
        if title == "Restore Last Session" {
            if enabled { return Alerts.restoreLast }
            else { return Alerts.homepage }
        }
        return Alerts.other
    }
    
    /*
    static func confirmHome() -> Bool {
        
        let alert = UIAlertController(title: "Did you bring your towel?", message: "It's recommended you bring your towel before continuing.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    */
    
}

