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
    @IBOutlet var textField: UITextField!

    override func loadView() {
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "https://html5test.com")!
        webView.loadRequest(NSURLRequest(URL: url))
        webView.allowsBackForwardNavigationGestures = true
        
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
    
    func textFieldDidUpdate(sender: UITextField) {
        if (sender.text!.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet()) != nil) {
            // Test for search term based on spacing
            guard
                let text = sender.text,
                query = text.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet()),
                url = NSURL(string: "https://google.com/#q=\(query)")
            else { return }
        
            webView.loadRequest(NSURLRequest(URL: url))
        
        } else {
            
            // Test for valid URL (NSURL-Extensions)
            NSURL.validateUrl(sender.text, completion: { (success, urlString, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if (success) {
                        let request = NSURLRequest(URL: NSURL(string: urlString!)!)
                        self.webView.loadRequest(request)
                        print("Succes, should loading.")
                    } else {
                        self.webView.stopLoading()
                        print("Error, failed to load.")
                    }
                })
            })
        }
    }
}
