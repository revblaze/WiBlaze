//
//  SettingsViewController.swift
//  WiBlaze
//
//  Created by Justin Bush on 2020-08-12.
//  Copyright © 2020 Justin Bush. All rights reserved.
//

import UIKit
import QuickTableViewController

final class SettingsViewController: QuickTableViewController {
    
    
    private let debugging = Section(title: nil, rows: [NavigationRow(text: "", detailText: .none)])
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Preferences"
        
        var prettyHome = Pretty.url(Settings.homeURL!)//Pretty.url(Default.homeURL!)
        if let custom = Settings.homeURL { prettyHome = Pretty.url(custom) }
        else { prettyHome = Pretty.url(Default.homeURL!) }
        
        tableContents = [
            
            Section(title: "Launch", rows: [
                SwitchRow(text: "Restore Last Session", detailText: .subtitle("Set a custom homepage URL"), switchValue: Settings.restoreLastSession, icon: .image(Glyph.restoreLast!), action: didToggleSwitch()),
                NavigationRow(text: "Custom Homepage", detailText: .subtitle("Current: \(prettyHome)"), icon: .image(Glyph.home!), accessoryButtonAction: showDetail())
            ], footer: "Upon launching WiBlaze, you can either load your last page or start fresh with a custom homepage"),
            
            Section(title: "Reset", rows: [
                TapActionRow(text: "Restore Default Settings", action: showAlert())
            ], footer: "This will restore all Settings to their default state"),
            
            /*
             Section(title: "Switch", rows: [
             SwitchRow(text: "Setting 1", detailText: .subtitle("Example subtitle"), switchValue: true, icon: .image(globe), action: didToggleSwitch()),
             SwitchRow(text: "Setting 2", switchValue: false, icon: .image(time), action: didToggleSwitch())
             ]),
             
             Section(title: "Tap Action", rows: [
             TapActionRow(text: "Tap action", action: showAlert())
             ]),
             
             Section(title: "Navigation", rows: [
             NavigationRow(text: "CellStyle.default", detailText: .none, icon: .image(gear)),
             NavigationRow(text: "CellStyle", detailText: .subtitle(".subtitle"), icon: .image(globe), accessoryButtonAction: showDetail()),
             NavigationRow(text: "CellStyle", detailText: .value1(".value1"), icon: .image(time), action: showDetail()),
             NavigationRow(text: "CellStyle", detailText: .value2(".value2"))
             ], footer: "UITableViewCellStyle.Value2 hides the image view."),
             
             RadioSection(title: "Radio Buttons", options: [
             OptionRow(text: "Option 1", isSelected: true, action: didToggleSelection()),
             OptionRow(text: "Option 2", isSelected: false, action: didToggleSelection()),
             OptionRow(text: "Option 3", isSelected: false, action: didToggleSelection())
             ], footer: "See RadioSection for more details."),
             */
            
            debugging
            
        ]
        
    }
    
    
    
    // MARK:- Functions
    
    
    
    
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // Alter the cells created by QuickTableViewController
        return cell
    }
    
    // MARK: - Private Methods
    
    private func didToggleSelection() -> (Row) -> Void {
        return { [weak self] in
            if let option = $0 as? OptionRowCompatible {
                let state = "\(option.text) is " + (option.isSelected ? "selected" : "deselected")
                self?.showDebuggingText(state)
            }
        }
    }
    
    private func didToggleSwitch() -> (Row) -> Void {
        return { [weak self] in
            if let row = $0 as? SwitchRowCompatible {
                let state = "\(row.text) = \(row.switchValue)"
                self?.showDebuggingText(state)
                
                let alert = ActionManager.getAlert(row.text, enabled: row.switchValue)
                self?.showAlert(alert)
                
                Settings.save(row.switchValue, forKey: Keys.restoreLastSession)
                
                
            }
        }
    }
    
    private func showAlert() -> (Row) -> Void {
        return { [weak self] _ in
            let alert = UIAlertController(title: "Action Triggered", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showDetail() -> (Row) -> Void {
        return { [weak self] in
            let detail = $0.text + ($0.detailText?.text ?? "")
            let controller = UIViewController()
            controller.view.backgroundColor = .white
            controller.title = detail
            
            if detail.contains("Custom Homepage") {
                self?.showAlert(Alerts.setHomeInfo)
            } else {
                self?.navigationController?.pushViewController(controller, animated: true)
            }
            self?.showDebuggingText(detail + " is selected")
        }
    }
    
    
    private func showDebuggingText(_ text: String) {
        print(text)
        debugging.rows = [NavigationRow(text: text, detailText: .none)]
        if let section = tableContents.firstIndex(where: { $0 === debugging }) {
            tableView.reloadSections([section], with: .none)
        }
    }
    
    
    func showAlert(_ title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func showAlert(_ alert: Alerts) {
        let alert = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        //alert.addAction(UIAlertAction(title: "Save", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

