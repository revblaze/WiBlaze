//
//  SettingsViewController.swift
//  WiBlaze
//
//  Created by Justin Bush on 2017-01-18.
//  Copyright © 2017 Justin Bush. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    let defaults = UserDefaults.standard
    
    @IBOutlet var homeSwitch: UISwitch!
    @IBOutlet var customHome: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Default Settings on First Launch
        let firstLaunch = defaults.bool(forKey: "firstLaunch")
        let switchStatus = defaults.bool(forKey: "customHomepage")
        
        
        if firstLaunch {
            // Disable First Lunach Check
            defaults.set(true, forKey: "launchedBefore")
            defaults.set(false, forKey: "customHomepage")
        }
        
        if let homepage = defaults.string(forKey: "homepageURL") {
            customHome.text = homepage
        }
        
        // Save Switch Status
        if switchStatus {
            homeSwitch.isOn = true
        } else {
            homeSwitch.isOn = false
        }
        
        //
        
        // Custom Back Arrow
        let inserts = UIEdgeInsets(top: 0, left: 0, bottom: -4, right: 0)
        let backArrow = UIImage(named: "Back")?.withAlignmentRectInsets(inserts)
        self.navigationController?.navigationBar.backIndicatorImage = backArrow
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backArrow
        
        // Set Placeholder Style
        customHome.attributedPlaceholder = NSAttributedString(string:" http://", attributes: [NSForegroundColorAttributeName: UIColor.gray])
    }
    
    @IBAction func checkState(_ sender: AnyObject) {
        
        if homeSwitch.isOn {
            defaults.set(true, forKey: "customHomepage")
            print("Custom Homepage Enabled")
        }
        
        if homeSwitch.isOn == false {
            defaults.set(false, forKey: "customHomepage")
            print("Return Default Homepage")
        }
        
    }
    
    // Setup Custom Homepage
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        customHome.resignFirstResponder()
        print("Custom Homepage URL:", customHome.text!)
        
        if customHome.text == "" {
            defaults.set("https://google.com", forKey: "homepageURL")
        } else {
            defaults.set(customHome.text, forKey: "homepageURL")
        }
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

