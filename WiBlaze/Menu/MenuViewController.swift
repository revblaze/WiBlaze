//
//  MenuViewController.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-05-05.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import UIKit


protocol Menu: class {
    
    func showMenu(_ show: Bool)
    
}


class MenuViewController: UIViewController {
    
    @IBOutlet var menuView: UIView!
    @IBOutlet var menuFX: UIVisualEffectView!
    
    weak var delegate: Menu?

    override func viewDidLoad() {
        menuFX.layer.cornerRadius = 20.0
        menuFX.layer.masksToBounds = true
        menuView.layer.cornerRadius = 20.0
        menuView.layer.masksToBounds = true
        
        super.viewDidLoad()

        
    }
    
    // Detect taps outside of Menu area
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first
        next?.touchesBegan(touches, with: event)
        
        if touch?.view != menuView {
            delegate?.showMenu(false)
            if debug { print("User clicked outside of Menu area") }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if debug { print("Segue Performed for: \(segue)") }
        if segue.identifier == "MenuSegue" {
            let customizer = segue.destinationController as! CustomizerViewController
            customizer.delegate = self          // Assign Customizer delegate to self
        }
    }
    */

}
