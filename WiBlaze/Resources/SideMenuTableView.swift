//
//  SideMenuTableView.swift
//  SideMenu
//
//  Created by Jon Kent on 4/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import SideMenu
import Fabric
import Crashlytics

@objc protocol SideMenuTableViewDelegate {
    @objc optional func refreshClicked()
    @objc optional func goHomeClicked()
    @objc optional func requestDesktop()
    @objc optional func showSourceCode()
}

class SideMenuTableView: UITableViewController {
    
    var delegate: SideMenuTableViewDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // this will be non-nil if a blur effect is applied
        guard tableView.backgroundView == nil else {
            return
        }
        
        // Set up a cool background image for demo purposes
        let imageView = UIImageView(image: UIImage(named: "Tile"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        tableView.backgroundView = imageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.setNeedsDisplay()
            self.tableView.reloadData()
        })
    }
    
    @IBAction fileprivate func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refresh(sender: AnyObject!) {
        NotificationCenter.default.post(name: Notification.Name("RefreshNotification"), object: nil)
        close()
        print("Active Refresh")
        Answers.logContentView(withName: "Refresh Page",
                                       contentType: "Menu",
                                       contentId: "menuitem-01",
                                       customAttributes: [:])
    }
    
    @IBAction func goHome(sender: AnyObject!) {
        NotificationCenter.default.post(name: Notification.Name("GoHomeNotification"), object: nil)
        close()
        print("Go to Homepage")
        Answers.logContentView(withName: "Load Homepage",
                               contentType: "Menu",
                               contentId: "menuitem-02",
                               customAttributes: [:])
    }
    
    @IBAction func requestDesktop(sender: AnyObject!) {
        NotificationCenter.default.post(name: Notification.Name("RequestDesktopNotification"), object: nil)
        close()
        print("Request Desktop Site")
        Answers.logContentView(withName: "Request Desktop Site",
                               contentType: "Menu",
                               contentId: "menuitem-03",
                               customAttributes: [:])
    }
    
    @IBAction func showSource(sender: AnyObject!) {
        NotificationCenter.default.post(name: Notification.Name("ShowSourceCodeNotification"), object: nil)
        close()
        print("Show WebView Source Code")
        Answers.logContentView(withName: "Show Page Source",
                               contentType: "Menu",
                               contentId: "menuitem-04",
                               customAttributes: [:])
    }
    
    @IBAction func inDevelopment(sender: AnyObject!) {
        let alert = UIAlertController(title: "Under Development", message: "This feature is currently under development and will be available in the coming updates.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        Answers.logContentView(withName: "Under Development",
                               contentType: "Menu",
                               contentId: "menuitem-05",
                               customAttributes: [:])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}

