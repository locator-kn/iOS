//
//  ImpressionFeedVC.swift
//  locator
//
//  Created by Michael Knoch on 24/02/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class ImpressionFeedVC: UITableViewController {

    var impressions: [AbstractImpression]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        ImpressionService.getImpressions("569e4a9a4c9d7b5f3b400709").then {
            result -> Void in
            self.impressions = result
            self.tableView.reloadData()
            self.tableView.rowHeight = UITableViewAutomaticDimension
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.impressions == nil {
            return 0
        }
        return self.impressions!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let impression = impressions![indexPath.row]
        
        if let imageImpression = impression as? ImageImpression {
            let cell = tableView.dequeueReusableCellWithIdentifier("imageImpression", forIndexPath: indexPath) as! ImageImpressionCell
            //cell.imageBox.image = UIImage(data: UtilService.dataFromPath("https://locator-app.com" + imageImpression.imagePath))
            
            UtilService.dataFromCache(API.IMAGE_URL + imageImpression.imagePath).then {
                result -> Void in
                print("start")
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? ImageImpressionCell {
                    cellToUpdate.imageBox.image = UIImage(data: result)
                }
            }
            
            return cell
            
        } else if let textImpression = impression as? TextImpression {
            let cell = tableView.dequeueReusableCellWithIdentifier("textImpression", forIndexPath: indexPath) as! TextImpressionCell
            cell.textView.text = textImpression.text
            return cell
        }
        
        return UITableViewCell()
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
