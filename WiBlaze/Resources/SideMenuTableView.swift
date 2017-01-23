//
//  SideMenuTableView.swift
//  SideMenu
//
//  Created by Jon Kent on 4/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import SideMenu

class SideMenuTableView: UITableViewController {
    
    var delegate: MainViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // this will be non-nil if a blur effect is applied
        guard tableView.backgroundView == nil else {
            return
        }
        
        // Set up a cool background image for demo purposes
        let imageView = UIImageView(image: UIImage(named: "Stars"))
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
        delegate?.refresh()
        close()
        print("Active Refresh")
    }
    
    @IBAction func inDevelopment(sender: AnyObject!) {
        let alert = UIAlertController(title: "Under Development", message: "This feature is currently under development and will be available in the next update.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}
