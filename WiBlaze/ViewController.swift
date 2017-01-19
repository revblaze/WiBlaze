//
//  ViewController.swift
//  WiBlaze
//
//  Created by Justin Bush on 2017-01-15.
//  Copyright © 2017 Justin Bush. All rights reserved.
//

import UIKit
import WebKit
import ActivityNavigationBar
import SideMenu

protocol MainViewControllerDelegate {
    func refresh()
}

class ViewController: UIViewController, UINavigationControllerDelegate, WKNavigationDelegate, UITextFieldDelegate, MainViewControllerDelegate {

    let defaults = UserDefaults.standard
    
    var webView: WKWebView!

    @IBOutlet var addressBar: UITextField!
    @IBOutlet var backButton: UIBarButtonItem!
    
    // App Screen Bounds
    var appScreenRect: CGRect {
        let appWindowRect = UIApplication.shared.keyWindow?.bounds ?? UIWindow().bounds
        return appWindowRect
    }
    
    override func loadView() {
        // Setup WebKit
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webConfiguration.preferences.javaScriptEnabled = true
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressBar.delegate = self
        var homepageURL: String!
        
        // Set Placeholder Style
        addressBar.attributedPlaceholder = NSAttributedString(string:" Search or type URL", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        
        // Set Homepage
        if defaults.bool(forKey: "customHomepage") {
            
            if let homepageURL = defaults.string(forKey: "homepageURL") {
                // Custom Homepage is Enabled
                let webURL = URL(string: homepageURL)
                let webRequest = URLRequest(url: webURL!)
                webView.load(webRequest)
                print("Load Custom Homepage:", homepageURL)
                
            } else {
                // No Custom Homepage, Load Default
                homepageURL = "https://google.com"
                let webURL = URL(string: homepageURL)
                let webRequest = URLRequest(url: webURL!)
                webView.load(webRequest)
            }
            
        } else {
            // No Custom Homepage, Load Default
            homepageURL = "https://google.com"
            let webURL = URL(string: homepageURL)
            let webRequest = URLRequest(url: webURL!)
            webView.load(webRequest)
        }
        
        // Set WebKit Load Configurations
        webView.allowsBackForwardNavigationGestures = true
        
        // Setup Menu Controller
        let menuRightNavigationController = UISideMenuNavigationController()
        SideMenuManager.menuRightNavigationController = menuRightNavigationController
        SideMenuManager.menuBlurEffectStyle = .dark
        SideMenuManager.menuPresentMode = .menuSlideIn
        
        // Set Menu Width (eg. * 0.65 = 65%)
        SideMenuManager.menuWidth = max(round(min((appScreenRect.width), (appScreenRect.height)) * 0.65), 240)
    }
    
    // Setup Address Bar
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addressBar.resignFirstResponder()
        print("User Requested:", addressBar.text!)
        loadURL(address: addressBar.text!)
        return true
    }

    // Toggle Back Button
    func checkBack() {
        if webView.canGoBack {
            backButton.isEnabled = true
        } else {
            backButton.isEnabled = false
        }
    }
    
    // Validate URL
    func validateURL(urlString: String) -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }
    
    // Format URL Scheme
    func formatURL(userRequest: String) -> String {
        
        var formattedURL: String
        
        // Check if userRequest only contains URL prefixes
        let prefixes = ["http://", "https://", "www.", "http://www.", "https://www."]
        
        if validateURL(urlString: userRequest) {
            // userRequest is a valid URL
            if prefixes.contains(userRequest) {
                // URL does have prefix
                formattedURL = userRequest
            } else {
                // Format URL and add prefix
                formattedURL = "http://" + userRequest
            }
            
            print("Load URL:", formattedURL)
            return formattedURL
            
        } else {
            
            // userRequest is not a valid URL, load search query
            let searchQuery = userRequest.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            let searchEngine = "https://google.com/#q="
            let searchURL = searchEngine + searchQuery
            print("Load Search:", searchURL)
            return searchURL
        }
    }
    
    // Load URL in the WebView
    func loadURL(address: String) {
        let address = formatURL(userRequest: address)
        let webURL = URL(string: address)
        let webRequest = URLRequest(url: webURL!)
        webView.load(webRequest)
    }
    
    // WebView Called for Navigation
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityNavigationBar?.startActivity(andWaitAt: 0.8)
    }
    
    // WebView Started Downloading Content
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        checkBack()
        
        if webView.estimatedProgress < 0.8 {
            activityNavigationBar?.finishActivity(withDuration: 0.8)
        } else {
            activityNavigationBar?.finishActivity(withDuration: webView.estimatedProgress)
        }
    }
    
    // WebView Finished Loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        addressBar.text = webView.url?.absoluteString
        activityNavigationBar?.reset()
    }
    
    // Setup Activity Navigation
    var activityNavigationBar: ActivityNavigationBar? {
        return navigationController?.navigationBar as? ActivityNavigationBar
    }
    
    // Set Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // Go Back to Previous WebPage
    @IBAction func goBack(sender: AnyObject) {
        webView.goBack()
    }
    
    // Refresh WebView Content
    func refresh() {
        webView.reload()
        print("Refresh Page")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? SideMenuTableView {
            vc.delegate = self
        }
    }
}
