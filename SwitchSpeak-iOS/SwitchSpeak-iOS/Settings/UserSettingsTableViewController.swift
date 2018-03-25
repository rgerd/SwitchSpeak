//
//  UserSettingsTableViewController.swift
//  SwitchSpeak-iOS
//
//  Created by Robert Gerdisch on 3/22/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import UIKit

class UserSettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalSettings.countUsers() + 1 // We add 1 here for the addition cell when in editing mode
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "UserSettingsTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserSettingsTableViewCell else {
            fatalError("The dequeued cell is not an instance of UserSettingsTableViewCell.")
        }
        
        if indexPath.row == GlobalSettings.countUsers() {
            cell.useSettings(nil)
            return cell
        }
        
        let settings = GlobalSettings.userSettings[indexPath.row]
        
        cell.userId = indexPath.row
        cell.requestTableReload = reloadTable
        cell.setLoggedIn(GlobalSettings.currentUserId == indexPath.row)
        cell.useSettings(settings)
        
        return cell
    }
    
    func reloadTable() {
        (self.view as! UITableView).reloadData()
    }
    
    @IBAction func editName(_ lpgr: UILongPressGestureRecognizer) {
        if(lpgr.state != .began) {
            return
        }
        
        let pressedLocation = lpgr.location(in: tableView)
        if let pressedIndexPath = tableView.indexPathForRow(at: pressedLocation) {
            if let pressedCell = tableView.cellForRow(at: pressedIndexPath) {
                let editAlert:UIAlertController = (pressedCell as! UserSettingsTableViewCell).editName()
                self.present(editAlert, animated: true, completion: nil)
            }
        }
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if parent != self.parent {
            return
        }
        GlobalSettings.saveUserSettings()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.row == 0 {
                return
            }
            // Delete the row from the data source
            GlobalSettings.removeUser(byId: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            GlobalSettings.createUser()
            reloadTable()
        }    
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row >= GlobalSettings.countUsers() {
            return .insert
        } else {
            return .delete
        }
    }
 

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
