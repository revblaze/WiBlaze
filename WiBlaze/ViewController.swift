//
//  ViewController.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-07-14.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import UIKit
import WebKit

let debug = true

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UITextFieldDelegate {

    // UI Elements
    @IBOutlet weak var webView: WKWebView!                  // Main WebView
    @IBOutlet weak var textField: UITextField!              // URLSearchBar
    @IBOutlet weak var menuButton: UIBarButtonItem!         // Menu Button
    @IBOutlet weak var backButton: UIBarButtonItem!         // Back Button
    @IBOutlet weak var secureButton: UIBarButtonItem!       // Secure Icon
    
    // Observers
    // WebView Observers
    var webViewURLObserver: NSKeyValueObservation?          // Observer for URL
    var webViewTitleObserver: NSKeyValueObservation?        // Observer for Page Title
    var webViewProgressObserver: NSKeyValueObservation?     // Observer for Load Progress
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    
    
    
    
    // MARK:- TextField Width
    // Device did change orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        widenTextField()
        if UIDevice.current.orientation.isLandscape { if debug { print("New Orientation: Landscape") } }
        else { if debug { print("New Orientation: Portrait") } }
    }
    
    /// Resizes `UITextField` in `UINavigationBar` to maximum possible width (called on device rotation)
    func widenTextField() {
        var frame: CGRect? = textField?.frame
        frame?.size.width = 10000
        textField?.frame = frame!
    }

}

