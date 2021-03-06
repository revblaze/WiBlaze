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
    @IBOutlet weak var topConstraint: NSLayoutConstraint!   // Top Bar Constraint
    
    // WebView Observers
    var webViewURLObserver: NSKeyValueObservation?          // Observer for URL
    var webViewTitleObserver: NSKeyValueObservation?        // Observer for Page Title
    var webViewProgressObserver: NSKeyValueObservation?     // Observer for Load Progress
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showMenu(false, withAnimation: false)               // Hide Menu on Launch
        
        // Initializers
        initWebView()               // Initalize WebView
        widenTextField()            // Set URLSearchBar constraints
        
        /*
        if !Settings.hasLaunchedBefore {
            Settings.setDefaults()
        }
        */
        
        // OBSERVER: WebView URL (Detect Changes)
        webViewURLObserver = webView.observe(\.url, options: .new) { [weak self] webView, change in
            self?.urlDidChange("\(String(describing: change.newValue))") }
        
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
        webView.load(Settings.getLaunchURL())
        
        //progressBar.progress = 0
        //progressBar.alpha = 0
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Debug.log("webView didStartProvisionalNavigation")
        let urlString = webView.url?.absoluteString
        alignText()
        updateTextField(pretty: false)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        Debug.log("webView didCommit")
        let urlString = webView.url?.absoluteString
        // TEMP: Print warning workaround
        print(Query.getLoadable(urlString!))
        Query.updateURL(urlString!)
        
        alignText()
        updateTextField(pretty: true)
        resize(urlString!)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Debug.log("webView didFinish")
        let urlString = webView.url?.absoluteString
        
        alignText()
        updateTextField(pretty: true)
        
        let secureColor = UIColor(named: "Secure")
        //let insecureColor = UIColor(named: "Primary")
        let grayColor = UIColor(named: "Disabled")
        
        if urlString!.contains("https://") {
            secureButton.tintColor = secureColor
            //menuButton.tintColor = secureColor
        } else {
            secureButton.tintColor = grayColor
        }
        
        Settings.save(Live.fullURL, forKey: Keys.lastSessionURL)
        resize(urlString!)
        
    }
    
    // TODO: Figure out how to resize WebView when facing sites like YouTube
    // The code below fixes the YouTube layout issue, but messes up every website that follows
    func resize(_ url: String) {
        topConstraint.constant = navBarHeight
        /*
        if Site.needsFullScreen(url) {
            topConstraint.constant = navBarHeight
            Debug.log("FullScreen URL: \(Live.fullURL), withHeight: \(navBarHeight)")
        } else {
            topConstraint.constant = 0
            Debug.log("New Constraint: \(topConstraint.constant)")
        }
        */
        
    }
    
    
    
    // MARK:- URL Did Change
    func urlDidChange(_ urlString: String) {
        let url = Clean.url(urlString)
        Debug.log("URL: \(url)")        // Debug: Print URL to Load
        resize(url)                     // Resize Layout for Specific Domains
    }
    
    
    
    
    // MARK:- Navigation Bar
    
    /// Prompts the CircleMenu handler to manage display
    @IBAction func showCircleMenu(_ sender: Any) {
        let hiddenMenu = circleMenuButton.isHidden
        if hiddenMenu { circleMenuButton.onTap() }
        showMenu(hiddenMenu, withAnimation: !hiddenMenu)
    }
    
    
    
    
    // MARK:- Menu Functions
    /// Load homepage in WebView
    func loadHomepage() {
        webView.load(Settings.getHomepage())
    }
    /// Reload current WebView URL
    func refresh() {
        webView.reload()
    }
    /// Add page to favourite
    func favouritePage() {
        Debug.log("Favourite Page")
        setCustomHome()
    }
    /// Segue Bookmarks ViewController
    func openBookmarks() {
        Debug.log("Open Bookmarks")
    }
    /// Open Action sheet
    func openAction() {
        Debug.log("Open Share Action")
        let items = [URL(string: Live.fullURL)!]
        let actionSheet = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(actionSheet, animated: true)
    }
    /// Segue Settings ViewController
    func openSettings() {
        print("Open Settings")
        let settingsVC = SettingsViewController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    
    
    
    // MARK:- Extended Functions
    func setCustomHome() {
        let home = Alerts.customHome
        let alert = UIAlertController(title: home.title, message: home.message, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            Settings.save(Live.fullURL, forKey: Keys.homepageString)
            Settings.save(false, forKey: Keys.restoreLastSession)
            Settings.restoreLiveSession = false
            self.doneCustomHomeAlert()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func doneCustomHomeAlert() {
        let done = Alerts.setHome
        let alert = UIAlertController(title: done.title, message: done.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    
    
    // MARK:- TextField Handler
    
    func updateTextField(pretty: Bool) {
        Debug.log("Query.isSearchTerm: \(Query.isSearchTerm)")
        alignText() // TEMP: NEEDED?
        // Case: Search Term
        if Query.isSearchTerm {                     //if !Live.isURL {
            textField.text = Live.searchTerm
        // Case: Pretty URL
        } else if !Query.isSearchTerm && pretty {   //} else if Live.isURL && pretty {
            textField.text = Live.prettyURL
        // Case: Full URL
        } else {
            if (textField.text?.contains(Live.fullURL))! {
                textField.text = Live.prettyURL
            } else {
                textField.text = Live.fullURL
            }
        }
        Live.debug()
    }
    
    var firstLoad = true
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        alignText()
        // Case: First Load
        if firstLoad {
            textField.text = ""             // Empty TextField upon first selection
            firstLoad = false               // Set firstLoad to false
        } else {
            updateTextField(pretty: false)  // Set full URL or search query
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        alignText()
        textField.becomeFirstResponder()
        textField.selectAll(nil)
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let url = Query.getLoadable(textField.text!)
        updateTextField(pretty: false)   // TEMP: NEEDED?
        webView.load(url)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateTextField(pretty: false) // TEMP: NEEDED?
        hideKeyboard()
    }
    // TextField: Denies entry to non-ASCII characters (ie. emojis)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.canBeConverted(to: String.Encoding.ascii) { return false }
        return true
    }
    /// Aligns content of TextField based on search or URL
    func alignText() {
        if textField.isEditing {
            textField.textAlignment = .left
        /*
        } else if webView.isLoading && !Query.isSearchTerm {
            textField.textAlignment = .left
        */
        } else {
            textField.textAlignment = .center
        }
    }
    /// Manually hides keyboard
    func hideKeyboard() {
        textField.resignFirstResponder()
        //checkSecureAndUpdate()
    }
    
    
    
    
    // MARK:- Circle Menu
    
    // Option 1: Home,     Refresh,   Fav/Save & Share,   History & Bookmarks,   Actions,           Settings
    // Option 2: Home,     Refresh,   Fav/Save,           History & Bookmarks,   Share & Actions,   Settings *
    // Colors 1: Orange,   Blue,      Red,                Purple,                Green,             Gray
    // Colors 2: Purple,   Blue,      Red,                Orange,                Green,             Gray     *
    // ACTIONS: Different from ShareSheet; Actions will allow you to manipulate the content of the Web Browser (ie. view source code, request desktop site, JavaScript console with injection, etc.)
    // TODO: Find appropriate place to implement Print, possibly in Share or Actions
    
    //    let colors = [UIColor.redColor(), UIColor.grayColor(), UIColor.greenColor(), UIColor.purpleColor()]
    let items: [(icon: String, color: UIColor)] = [
        ("menu_home", UIColor(red: 0.49, green: 0.37, blue: 1.00, alpha: 1)),           // Home
        ("menu_refresh", UIColor(red: 0.00, green: 0.47, blue: 1.00, alpha: 1)),        // Refresh
        ("menu_share", UIColor(red: 0.03, green: 0.82, blue: 0.45, alpha: 1)),          // Share / Action
        ("menu_settings", UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)),       // Settings
        ("menu_bookmarks", UIColor(red: 1.00, green: 0.62, blue: 0.10, alpha: 1)),      // Bookmarks
        ("menu_favourite", UIColor(red: 1.00, green: 0.22, blue: 0.22, alpha: 1))       // Favourite
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
        Debug.log("Menu: button will selected: \(atIndex)")
        showMenu(false, withAnimation: false)
    }

    func circleMenu(_: CircleMenu, buttonDidSelected _: UIButton, atIndex: Int) {
        Debug.log("Menu: button did selected: \(atIndex)")
        showMenu(false, withAnimation: false)
        if atIndex == 0 { loadHomepage() }
        else if atIndex == 1 { refresh() }
        else if atIndex == 2 { openAction() }
        else if atIndex == 3 { openSettings() }
        else if atIndex == 4 { openBookmarks() }
        else if atIndex == 5 { favouritePage() }
        else { print("Menu option is out of range") }
    }
    
    func menuCollapsed(_ circleMenu: CircleMenu) {
        Debug.log("Menu: collapsed")
        showMenu(false, withAnimation: true)
    }
    
    
    
    
    // MARK:- TextField Width
    // Device did change orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        widenTextField()
        if Device.isPortrait() {
            Debug.log("New Orientation: Portrait")
        } else {
            Debug.log("New Orientation: Landscape")
        }
        
        if UIDevice.current.orientation.isLandscape { Debug.log("New Orientation: Landscape") }
        else { Debug.log("New Orientation: Portrait") }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.resize(Live.fullURL)
        }
    }
    
    /// Resizes `UITextField` in `UINavigationBar` to maximum possible width (called on device rotation)
    func widenTextField() {
        var frame: CGRect? = textField?.frame
        frame?.size.width = 10000
        textField?.frame = frame!
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    

}


extension UIViewController {

    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    var navBarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}

