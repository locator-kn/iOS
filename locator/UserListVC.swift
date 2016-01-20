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
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        if showFollower {
            self.getFollower()
        } else {
            self.getFollowedBy()
        }
    }
    
    func getFollower() {
        
        //fetch user locations
        UserService.getFollower((user?.id!)!)
            .then {
                result -> Void in
                self.follower = result
                self.tableView.reloadData()
                print("Fetch Follower By user success", self.user?.id)
                print(self.follower)
            }
            .error {
                error -> Void in
                print("Buff buff, rauchwolken, kaputt")
                print(error)
        }
    }
    
    func getFollowedBy() {
        
        //fetch user locations
        UserService.getFollower((user?.id!)!)
            .then {
                result -> Void in
                self.follower = result
                self.tableView.reloadData()
                print("Fetch FollowedBy success", self.user?.id)
                print(self.follower)
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
        cell.userImage.image = singleFollower.profilImage
        cell.userImage = UtilService.roundImageView(cell.userImage)
    
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
