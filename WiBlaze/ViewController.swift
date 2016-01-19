//
//  ViewController.swift
//  WiBlaze
//
//  Created by Justin Bush on 2016-01-16.
//  Copyright © 2016 Justin Bush. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var loadingView: WKWebView!
    @IBOutlet var textField: UITextField!

    override func loadView() {
        view = webView
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.backgroundColor = UIColor.whiteColor()
        webView.opaque = true
        
        view = loadingView
        loadingView = WKWebView()
        loadingView.navigationDelegate = self
        loadingView.hidden = true
        loadingView.alpha = 0.5
        loadingView.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(webView)
        view.addSubview(loadingView)
        
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = NSURL(string: "about:blank")!
        webView.loadRequest(NSURLRequest(URL: url))
        webView.allowsBackForwardNavigationGestures = true
        
        let loadingURL = NSBundle.mainBundle().URLForResource("LoaderPhone", withExtension:"html")!
        self.loadingView.loadRequest(NSURLRequest(URL: loadingURL))
        
        // Notification observer for textField
        self.textField.addTarget(self, action: "textFieldDidUpdate:", forControlEvents: UIControlEvents.EditingChanged)
        
        // Notification observer for device orientation
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidRotate", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTextFieldWidth() {
        var frame: CGRect = self.textField.frame
        frame.size.width = self.view.frame.width
        self.textField.frame = frame
    }
    
    func userDidRotate() {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            print("Orientation Change: Landscape")
            setTextFieldWidth()
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            print("Orientation Change: Portrait")
            setTextFieldWidth()
        }
    }
    
    /*
    func textFieldDidUpdate(sender: UITextField) {
        guard
            let text = sender.text,
            query = text.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet()),
            url = NSURL(string: "https://google.com/#q=\(query)")
            else {
                if (sender.text?.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet()) != nil) {
                    NSURL.validateUrl(sender.text, completion: { (success, urlString, error) -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> () in
                            if (success) {
                                self.webView.hidden = false
                                guard
                                    let urlString = urlString,
                                    let requestURL = NSURL(string: urlString)
                                    else { return }
                                self.webView.loadRequest(NSURLRequest(URL: requestURL))
                            } else {
                                self.webView.stopLoading()
                            }
                        })
                    })
                }
                return
        }
        
        webView.hidden = false
        webView.loadRequest(NSURLRequest(URL: url))
    }
    */
    
    func textFieldDidUpdate(textField: UITextField) {
        if (textField.text!.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet()) != nil) {
            guard
                let text = textField.text,
                query = text.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet()),
                url = NSURL(string: "https://google.com/#q=\(query)")
                else { return }
            loadingView.hidden = true
            webView.loadRequest(NSURLRequest(URL: url))
        
        } else {
            // Validate URL
            NSURL.validateUrl(textField.text, completion: { (success, urlString, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if (success) {
                        self.loadingView.hidden = true
                        let request = NSURLRequest(URL: NSURL(string: urlString!)!)
                        print(urlString!)
                        self.webView.loadRequest(request)
                    } else {
                        self.webView.stopLoading()
                        self.loadingView.hidden = false
                        print("View is hidden")
                    }
                })
            })
        }
    }
}
