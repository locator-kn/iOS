//
//  UserListVC.swift
//  locator
//
//  Created by Michael Knoch on 20/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class UserListVC: UITableViewController {
    
    var follower:[User]?
    var user:User?
    var showFollower:Bool = true

    override func viewDidLoad() {
        
        print(showFollower)
        
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        if (showFollower) {
            self.getFollower()
        } else {
            self.getFollowedBy()
        }
    }
    
    func getFollower() {
        self.user!.getFollower()
            .then {
                result -> Void in
                self.follower = result
                self.tableView.reloadData()
            }
            .error {
                error -> Void in
                print("Buff buff, rauchwolken, kaputt")
                print(error)
        }
    }
    
    func getFollowedBy() {
        self.user!.getFollowedBy()
            .then {
                result -> Void in
                self.follower = result
                self.tableView.reloadData()
            }
            .error {
                error -> Void in
                print("Buff buff, rauchwolken, kaputt")
                print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if follower == nil {
            return 0
        }
        return follower!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "UserCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserCell
    
        let singleFollower = follower![indexPath.row]
    
        cell.userName.text = singleFollower.name
        cell.userImage = UtilService.roundImageView(cell.userImage)
        
        UtilService.dataFromCache(singleFollower.imagePathThumb!).then {
            result -> Void in
            
            if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? UserCell {
                cellToUpdate.userImage.image = UIImage(data: result)
            }
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "user" {
            if let destination = segue.destinationViewController as? UserVC {
                if let user = tableView.indexPathForSelectedRow?.row {
                    destination.user = follower![user]
                }
            }
        }
    }

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

}
