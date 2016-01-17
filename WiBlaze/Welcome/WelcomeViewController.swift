//
//  WelcomeViewController.swift
//  WiBlaze
//
//  Created by Justin Bush on 2016-01-16.
//  Copyright © 2016 Justin Bush. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet var initialBackground: UIImageView!
    @IBOutlet var welcomeBackground: UIImageView!
    
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            initialBackground.image = UIImage(named: "PadMountain")
            welcomeBackground.image = UIImage(named: "PadWelcome")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.welcomeBackground.fadeIn(2.0, delay: 2.5)
        self.continueButton.fadeIn(2.0, delay: 2.5)
        self.skipButton.fadeIn(2.0, delay: 2.5)
    }
    
    enum UIUserInterfaceIdiom: Int {
        case Unspecified
        case Phone
        case Pad
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
