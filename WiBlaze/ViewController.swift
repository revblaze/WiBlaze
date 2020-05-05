//
//  ViewController.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-04-28.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import UIKit
import WebKit

var debug = true

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UITextFieldDelegate {
    // Core Elements
    @IBOutlet var webView: WKWebView!                   // Main WebView
    @IBOutlet var textField: UITextField!               // URL Search Bar
    @IBOutlet var backNav: UIBarButtonItem!             // Left NavBar Item
    @IBOutlet var menuNav: UIBarButtonItem!             // Right NavBar Item
    @IBOutlet var progressBar: UIProgressView!          // Progress Bar Loader
    // WebView Observers
    var webViewURLObserver: NSKeyValueObservation?      // Observer for URL
    var webViewTitleObserver: NSKeyValueObservation?    // Observer for Page Title
    var webViewProgressObserver: NSKeyValueObservation? // Observer for Load Progress

    override func viewDidLoad() {
        super.viewDidLoad()
        
        widenTextField()            // Set TextField Width
        initWebView()               // Initialize WebView
        
        
        /*
        // OBSERVER: WebView URL (Detect Changes)
        webViewURLObserver = webView.observe(\.url, options: .new) { [weak self] webView, change in
        let url = "\(String(describing: change.newValue))"
        self?.urlDidChange(urlString: url); }
        // OBSERVER: WebView Title (Detect Changes)
        webViewTitleObserver = webView.observe(\.title, options: .new) { [weak self] webView, change in
        let title = "\(String(describing: change.newValue))"
        self?.titleDidChange(pageTitle: title); }
         */
        // OBSERVER: WebView Title (Detect Changes)
        webViewProgressObserver = webView.observe(\.estimatedProgress, options: .new) { [weak self] webView, change in
            self?.progressDidChange(progress: change.newValue ?? 100)
        }
    }
    
    
    func progressDidChange(progress: Double) {
        let value = Float(progress)
        print("Loading: \(value)")
        
        if value < 1 {
            showProgressBar(true)
            progressBar.progress = value
        } else {
            showProgressBar(false)
        }
        
        if value == 1.0 {
            //showProgressBar(false)
            print("PROGRESS = 1")
        }
    }
    
    
    
    // MARK: NavBar Handler
    
    func showNavItems(_ show: Bool) {
        if show {
            backNav.image = Glyph.secure
            menuNav.image = Glyph.menu
        } else {
            backNav.image = nil
            menuNav.image = nil
        }
        widenTextField()
    }
    
    func showSecure(_ show: Bool) {
        if show { backNav.image = Glyph.secure }
        else { backNav.image = nil }
        widenTextField()
    }
    
    
    
    
    // MARK: TextField Handler
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showSecure(false)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        textField.selectAll(nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let input = textField.text!
        webView.load(Query.toURL(input))
        
        if !input.isBlank() {
            //webView.load(Query.toURL(input))
        } else {
            textField.text = ""
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //showNavItems(true)
        
        if Query.isSearch { textField.text = Active.query }
        else { textField.text = Active.urlString! }
    }
    
    
    
    
    
    // MARK: WebView Setup
    /// Initializes `WebView` object
    func initWebView() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.configuration.preferences.javaScriptEnabled = true
        
        progressBar.progress = 0
        progressBar.alpha = 0
        
        webView.load("https://google.com")
        
        /*
        if Settings.restoreLastSession {
            webView.load(Settings.lastSessionURL!)
        } else {
            webView.load(Settings.homepage!)
        }
        */
    }
    
    
    
    // MARK: WebView Handler
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let url = webView.url!
        Active.url = url        // Set Active URL
        Active.urlString = url.absoluteString
        
        let urlString = url.absoluteString
        // If new URL is not a search query, update textField
        if !Query.updateSearch(urlString) {
            textField.text = urlString
        }
        
        showProgressBar(true)

        if url.isSecure() { showSecure(true) }
        else { showSecure(false) }
        
        print("Active.url: \(String(describing: Active.url!))")
        print("Active.urlString: \(String(describing: Active.urlString!))")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let url = webView.url!
        
        if Query.isSearch { textField.text = Active.query }
        else { textField.text = Active.urlString! }
        
        if url.isSecure() { showSecure(true) }
        else { showSecure(false) }
    }
    
    
    
    // MARK: Custom Functions
    /// Show/hide page progress bar
    func showProgressBar(_ show: Bool) {
        print("showProgressBar: \(show)")
        if show {
            //progressBar.isHidden = true
            progressBar.alpha = 1
        } else {
            //progressBar.progress = 0
            //progressBar.isHidden = false
            progressBar.alpha = 0
        }
    }
    
    
    
    // MARK: Rotation Handler
    
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

