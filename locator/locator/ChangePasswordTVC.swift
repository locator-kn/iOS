//
//  ChangePasswordTVC.swift
//  locator
//
//  Created by Sergej Birklin on 04/03/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit

class ChangePasswordTVC: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordRepeatTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 3
        }
        return 2
    }
    
    @IBAction func changePassword(sender: UIButton) {
        
        print("change PW")
        
        if oldPasswordTextField != nil {
            if newPasswordTextField.text!.characters.count < 4 {
                AlertService.simpleAlert(self, message: "Ups. Zu kurzes Passwort!")
            } else {
                if newPasswordTextField.text == newPasswordRepeatTextField.text {
                    // send request
                    UserService.changePassword(oldPasswordTextField.text!, newPassword: newPasswordRepeatTextField.text!).then({ status -> Void in
                        if status == true {
                            let alert = UIAlertController(title: "Super", message: "Dein Passwort wurde geändert.", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        }
                    })
                } else {
                    AlertService.simpleAlert(self, message: "Deine Passwörter stimmen nicht überein!")
                }
            }
        } else {
            AlertService.simpleAlert(self, message: "Ups. Bitte gebe dein altes Passwort ein!")
        }
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        switch textField {
        case textField == oldPasswordTextField:
            newPasswordTextField.resignFirstResponder()
            return true
        case textField == newPasswordTextField:
            newPasswordRepeatTextField.resignFirstResponder()
            return true
        default:
            return false
        }
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
    
    // Configure the cell...
    
    return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
