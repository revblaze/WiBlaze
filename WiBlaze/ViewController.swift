//
//  ViewController.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-04-28.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import UIKit
import WebKit

let defaults = UserDefaults.standard

var debug = true
var firstLoad = true

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UITextFieldDelegate {
    // Core Elements
    @IBOutlet var webView: WKWebView!                   // Main WebView
    @IBOutlet var textField: UITextField!               // URL Search Bar
    @IBOutlet var leftNav: UIBarButtonItem!             // Left NavBar Item
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
        
        // OBSERVER: WebView Progress (Detect Changes)
        webViewProgressObserver = webView.observe(\.estimatedProgress, options: .new) { [weak self] webView, change in
            self?.progressDidChange(progress: change.newValue ?? 1.0)
        }
    }
    
    
    
    // MARK: Progress Change
    func progressDidChange(progress: Double) {
        let value = Float(progress)         // Set Value as Float
        if debug { print("Loading: \(value)") }
        
        if value < 1 {                      // While Page Loading:
            showProgressBar(true)           // Show Progress Bar
            progressBar.progress = value    // Set Progress Value
        } else {                            // When Page is Done:
            showProgressBar(false)          // Hide Progress Bar
        }
    }
    
    
    
    // MARK: NavBar Handler
    /// Hide/show navigation bar items
    func showNavItems(_ show: Bool) {
        if show {
            leftNav.image = Glyph.secure
            menuNav.image = Glyph.menu
        } else {
            leftNav.image = nil
            menuNav.image = nil
        }
        widenTextField()
    }
    /// Hide/show left navigation bar items
    func showLeftNav(_ show: Bool) {
        if show { updateNav(Nav.getLeftNavID()) }
        else { leftNav.image = nil }
    }

    // ie. updateNav(.back)
    func updateNav(_ item: LeftNav) {
        leftNav.image = item.glyph
        leftNav.tintColor = item.color
        Nav.left = item.id
        widenTextField()
    }
    
    @IBAction func leftNavAction(_ sender: Any) {
        switch Nav.left {
        case 0:
            print("Back Button")
            webView.goBack()
        case 1:
            print("Secure Button")
            print("SECURE CHECK DONE")
        case 2:
            print("Reload Button")
            webView.reload()
        case 3:
            print("Dismiss Keyboard Button")
            textField.resignFirstResponder()
        default:
            print("Default")
        }
    }
    
    
    
    // MARK: TextField Handler
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let url = webView.url!
        //showLeftNav(false)
        updateNav(.close)      // showLeftNav(false)
        print("isSearch = \(Query.isSearch)\nQuery.updateSearch = \(Query.updateSearch(url.absoluteString))")
        
        if !firstLoad { updateLiveLoad(url.absoluteString) }
        else { textField.text = "" }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        alignText()
        textField.becomeFirstResponder()
        textField.selectAll(nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let input = textField.text!
        webView.load(Query.toURL(input))
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if Query.isSearch { textField.text = Active.query }     // Set TextField: Search Query
        else { textField.text = Active.urlString! }             // Set TextField: URL String
        hideKeyboard()
    }
    // TextField: Denies entry to non-ASCII characters (ie. emojis)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.canBeConverted(to: String.Encoding.ascii) { return false }
        return true
    }
    
    func hideKeyboard() {
        textField.resignFirstResponder()
        checkSecureAndUpdate()
    }
    
    
    
    // MARK: WebView Setup
    /// Initializes `WebView` object
    func initWebView() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.configuration.preferences.javaScriptEnabled = true
        webView.scrollView.keyboardDismissMode = .onDrag            // Hide Keyboard on WebView Drag
        
        progressBar.progress = 0
        progressBar.alpha = 0
        
        webView.load("https://google.com")
    }
    
    
    // MARK: WebView Handler
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let url = webView.url!
        Active.url = url                        // Set Active URL
        //Active.urlString = url.absoluteString   // Set Active URL as String
        let urlString = url.absoluteString

        showProgressBar(true)       // Show Progress Bar
        updateLiveLoad(urlString)   // Update TextField while Loading
        checkSecureAndUpdate()      // Check Secure & Toggle Icon
        
        print("Active.url: \(String(describing: Active.url!))")
        print("Active.urlString: \(String(describing: Active.urlString!))")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let url = webView.url!
        updateTextField()           // Update TextField with Query or BaseURL
        checkSecureAndUpdate()      // Check Secure and Toggle Icon
        initLoadCheck()             // Keep TextField Placeholder on First Load
        
        if debug { print("didFinish: \(url.absoluteString)") }
    }
    
    
    /// Checks URL while loading or when going back
    func updateLiveLoad(_ urlString: String) {
        if !Query.updateSearch(urlString) { textField.text = urlString }
        else { textField.text = Active.query; alignText() }
    }
    /// Checks if URL is a search term or URL and updates `textField` with either `query` or `baseURL`
    func updateTextField() {
        let url = webView.url!
        if Query.isSearch { textField.text = Active.query }
        else { textField.text = Query.toBase(url) }
        alignText()
    }
    /// Checks if URL is secure (HTTPS) and updates nav item; also calls `alignText()`
    func checkSecureAndUpdate() {
        let url = webView.url!
        if url.isSecure() { updateNav(.secure) }
        else { updateNav(.reload) }
        alignText()
    }
    
    var loadCount = 0
    func initLoadCheck() {
        if loadCount < 1 { loadCount += 1 }
        else { firstLoad = false }
        if firstLoad { textField.text = "" }
    }
    
    
    
    // MARK: Custom Functions
    /// Show/hide page progress bar
    func showProgressBar(_ show: Bool) {
        if show { progressBar.alpha = 1 }
        else { progressBar.alpha = 0 }
    }
    
    func alignText() {
        if webView.isLoading && !Query.isSearch {
            textField.textAlignment = .left
        } else if textField.isEditing {
            textField.textAlignment = .left
        } else {
            textField.textAlignment = .center
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

