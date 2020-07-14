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

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UITextFieldDelegate, UIScrollViewDelegate, CircleMenuDelegate {

    // UI Elements
    @IBOutlet weak var webView: WKWebView!                  // Main WebView
    @IBOutlet weak var textField: UITextField!              // URLSearchBar
    @IBOutlet weak var menuButton: UIBarButtonItem!         // Menu Button
    @IBOutlet weak var backButton: UIBarButtonItem!         // Back Button
    @IBOutlet weak var secureButton: UIBarButtonItem!       // Secure Icon
    @IBOutlet weak var circleMenuButton: CircleMenu!        // CircleMenu Button
    
    // WebView Observers
    var webViewURLObserver: NSKeyValueObservation?          // Observer for URL
    var webViewTitleObserver: NSKeyValueObservation?        // Observer for Page Title
    var webViewProgressObserver: NSKeyValueObservation?     // Observer for Load Progress
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showMenu(false, withAnimation: false)               // Hide Menu on Launch
        
        // Initializers
        initWebView()
    }
    
    
    
    // MARK:- WebView
    func initWebView() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.customUserAgent = Browser.getUserAgent()            // Set Browser UserAgent
        // WebView Configuration
        let config = webView.configuration
        config.applicationNameForUserAgent = Browser.name           // Set Client Name
        config.preferences.javaScriptEnabled = true                 // Enable JavaScript
        // ScrollView Setup
        webView.scrollView.delegate = self
        webView.scrollView.isScrollEnabled = true                   // Enable Scroll
        webView.scrollView.keyboardDismissMode = .onDrag            // Hide Keyboard on WebView Drag

        // Load Homepage
        webView.load(Browser.defaultHome!)
        
        //progressBar.progress = 0
        //progressBar.alpha = 0
    }

    
    
    // MARK:- Navigation Bar
    
    /// Prompts the CircleMenu handler to manage display
    @IBAction func showCircleMenu(_ sender: Any) {
        let hiddenMenu = circleMenuButton.isHidden
        if hiddenMenu { circleMenuButton.onTap() }
        showMenu(hiddenMenu, withAnimation: !hiddenMenu)
    }
    
    
    
    // MARK:- Circle Menu
    
    // Option 1: Home,     Refresh,   Fav/Save & Share,   History & Bookmarks,   Actions,           Settings
    // Option 2: Home,     Refresh,   Fav/Save,           History & Bookmarks,   Share & Actions,   Settings *
    // Colors 1: Orange,   Blue,      Red,                Purple,                Green,             Gray
    // Colors 2: Purple,   Blue,      Red,                Orange,                Green,             Gray     *
    // ACTIONS: Different from ShareSheet; Actions will allow you to manipulate the content of the Web Browser (ie. view source code, request desktop site, JavaScript console with injection, etc.)
    
    //    let colors = [UIColor.redColor(), UIColor.grayColor(), UIColor.greenColor(), UIColor.purpleColor()]
    let items: [(icon: String, color: UIColor)] = [
        ("menu_home", UIColor(red: 0.19, green: 0.57, blue: 1, alpha: 1)),          // Home
        ("menu_settings", UIColor(red: 0.22, green: 0.74, blue: 0, alpha: 1)),      // Refresh
        ("menu_home", UIColor(red: 0.96, green: 0.23, blue: 0.21, alpha: 1)),       // Favourite
        ("menu_settings", UIColor(red: 0.51, green: 0.15, blue: 1, alpha: 1)),      // History/Bookmarks
        ("menu_home", UIColor(red: 0.96, green: 0.23, blue: 0.21, alpha: 1)),       // Share/Action
        ("menu_settings", UIColor(red: 1, green: 0.39, blue: 0, alpha: 1))          // Settings
    ]
    
    /**
     Toggle CircleMenu to hide or show, with optional animation
     - Parameters:
        - show: `Bool` value that specifies to show or hide the CircleMenu
        - withAnimation: `Bool` value that specifies if the CircleMenu collapsing should be animated
     
     The `withAnimation` value should only be set to `true` when using custom functions to close the CircleMenu
     */
    func showMenu(_ show: Bool, withAnimation: Bool) {
        if withAnimation { circleMenuButton.hideButtons(0.2) }
        circleMenuButton.isHidden = !show
    }
    
    
    // MARK: <CircleMenuDelegate>

    func circleMenu(_: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        button.setImage(UIImage(named: items[atIndex].icon), for: .normal)
        // Set highlighted image
        let highlightedImage = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }

    func circleMenu(_: CircleMenu, buttonWillSelected _: UIButton, atIndex: Int) {
        if debug { print("Menu: button will selected: \(atIndex)") }
        showMenu(false, withAnimation: false)
    }

    func circleMenu(_: CircleMenu, buttonDidSelected _: UIButton, atIndex: Int) {
        if debug { print("Menu: button did selected: \(atIndex)") }
        showMenu(false, withAnimation: false)
    }
    
    func menuCollapsed(_ circleMenu: CircleMenu) {
        if debug { print("Menu: collapsed") }
        showMenu(false, withAnimation: true)
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

