//
//  ViewController.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-04-23.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import UIKit
import WebKit

var debug = true

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UITextFieldDelegate {
    
    // Core Elements
    @IBOutlet var webView: WKWebView!               // Main WebView
    @IBOutlet var textField: UITextField!           // URL Search Bar
    // Navigation Bar Elements
    @IBOutlet var backButton: UIBarButtonItem!      // Back Button
    @IBOutlet var secureIcon: UIBarButtonItem!      // Secure Icon (HTTPS)
    @IBOutlet var starButton: UIBarButtonItem!      // Star/Favourites Button
    @IBOutlet var menuButton: UIBarButtonItem!      // Menu Button
    
    // WebView Observers
    var webViewURLObserver: NSKeyValueObservation?              // Observer for Web Player URL
    var webViewTitleObserver: NSKeyValueObservation?            // Observer for Web Player Title
    
    
    
    @IBAction func tempStarButtonToggle(_ sender: Any) {
        if debug { showSecure(true) }
        else { showSecure(false) }
        debug = !debug
    }
    
    
    
    // MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSecure(false)           // Hide Secure icon on launch
        
        widenTextField()            // Set TextField Width
        initWebView()               // Initialize WebView
        
        // OBSERVER: WebView URL (Detect Changes)
        webViewURLObserver = webView.observe(\.url, options: .new) { [weak self] webView, change in
        let url = "\(String(describing: change.newValue))"
        self?.urlDidChange(urlString: url); }
        // OBSERVER: WebView Title (Detect Changes)
        webViewTitleObserver = webView.observe(\.title, options: .new) { [weak self] webView, change in
        let title = "\(String(describing: change.newValue))"
        self?.titleDidChange(pageTitle: title); }
    }
    
    
    
    
    func urlDidChange(urlString: String) {
        let url = Clean.url(urlString)
        if URLHelper.isHTTPS(url) { showSecure(true) }
        else { showSecure(false) }
    }
    
    func titleDidChange(pageTitle: String) {
        Query.title = Clean.string(pageTitle)
    }
    
    
    
    
    func showSecure(_ show: Bool) {
        if show { secureIcon.image = UIImage(systemName: "lock.shield.fill") }
        else { secureIcon.image = nil }
    }
    
    
    
    // MARK: WebView Setup
    
    /// Initializes `WebView` object
    func initWebView() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        //webView.customUserAgent = Settings.userAgent()
        //webView.configuration.applicationNameForUserAgent = "WiBlaze"
        
        webView.configuration.preferences.javaScriptEnabled = true
        
        webView.load("https://google.com")
        /*
        if Settings.restoreLastSession {
            webView.load(Settings.lastSessionURL!)
        } else {
            webView.load(Settings.homepage!)
        }
        */
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //if URLHelper.isHTTPS(webView.url)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if Query.isSearch {
            textField.text = Query.text
        } else {
            let url = String(describing: webView.url)
            textField.text = Clean.url(url)
        }
    }
    
    
    
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



// MARK: Extensions

// WKWebView Extension
extension WKWebView {
    /// Quick load a URL in the WebView with ease
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
    /// Quick load a `file` (without `.html`) and `path` to the directory
    func loadFile(_ name: String, path: String) {
        if let url = Bundle.main.url(forResource: name, withExtension: "html", subdirectory: path) {
            self.loadFileURL(url, allowingReadAccessTo: url)
            let request = URLRequest(url: url)
            load(request)
        }
    }
}

