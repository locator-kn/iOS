//
//  ConversationsVC.swift
//  locator
//
//  Created by Timo Weiß on 22.02.16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class ConversationsVC: UITableViewController {
    
    var conversations:[Conversation]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 160.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        ConversationService.getShit().then {
            result -> Void in
            print(result)
            self.conversations = result
            self.tableView.reloadData()
        }

        //UserService.getUser("569e4a83a6e5bb503b838301").then {
        /*    result -> Void in
            
            self.users?.append(result)
            
        }*/
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
        // #warning Incomplete implementation, return the number of rows
        if conversations == nil {
            return 0
        }
        return conversations!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ConversationsCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ConversationsCell
        
        let singleConversation = conversations![indexPath.row]
        
        if let label = cell.username {
            for participant in singleConversation.participants {
                if participant.user_id != User.me?.id {
                    print("set text to username:", participant.user?.name)
                    label.text = participant.user?.name
                    print("imagepath:", participant.user!.imagePathThumb!)
                    
                    UtilService.roundImageView(cell.userImage)
                    
                    UtilService.dataFromCache(participant.user!.imagePathThumb!).then {
                        result -> Void in
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? ConversationsCell {
                            cellToUpdate.userImage.image = UIImage(data: result)
                        }
                        
                    }
                    
                }
            }
        }
        
        if let label = cell.messageTeaser {
            print(singleConversation.last_message.message)
            label.text = singleConversation.last_message.message
        }
        
        //cell.userImage = UtilService.roundImageView(cell.userImage)
        
//        UtilService.dataFromCache(singleFollower.imagePathThumb!).then {
//            result -> Void in
//            
//            if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? UserCell {
//                cellToUpdate.userImage.image = UIImage(data: result)
//            }
//        }
        
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
