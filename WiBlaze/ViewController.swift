//
//  ViewController.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-04-23.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWebView()
        setWidth()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setWidth()
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
        } else {
            print("Portrait")
        }
    }
    
    func initWebView() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load("https://google.ca")
    }
    
    func setWidth() {
        var frame: CGRect = textField.frame
        frame.size.width = self.view.frame.width
        print(frame.size.width)
        textField.frame = frame
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 16).isActive = true
        textField.layoutIfNeeded()
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

