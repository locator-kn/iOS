//
//  LocationList.swift
//  locator
//
//  Created by Michael Knoch on 16/01/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit

class LocationListVC: UITableViewController {

    var locations:[Location]?
    var user:User!
    var parentCtrl: UserTabVC?
    var showFavoritedLocations = false
    let locationPlaceholder = UIImage(named: "location_placeholder_small") as UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
        self.tableView.rowHeight = 80
        self.getLocationsByUser()
    }
    
    func getLocationsByUser() {
        
        //fetch user locations
        
        if !self.showFavoritedLocations {
        
            self.user!.getLocations().then {
                result -> Void in
                self.locations = result
                self.tableView.reloadData()
                print("Fetch Locations By user success", self.user?.id)
            }
            
        } else {
            
            self.user!.getFavoredLocations().then {
                result -> Void in
                self.locations = result
                self.tableView.reloadData()
                print("Fetch Locations By user success", self.user?.id)
            }
            
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
        if locations == nil {
            return 0
        }
        return locations!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "LocationCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LocationCell
        cell.layoutMargins = UIEdgeInsetsZero;
        
        let location = locations![indexPath.row]

        cell.locationTitle.text = location.title
        cell.locationCity.text = location.city.title
        UtilService.roundImageView(cell.locationImage, borderWidth: 3, borderColor: COLORS.red)
        
        if location.imagePathSmall != "" {
            UtilService.dataFromCache(location.imagePathSmall).then {
                result -> Void in
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? LocationCell {
                    cellToUpdate.locationImage.image = UIImage(data: result)
                }
            }
        } else {
            cell.locationImage.image = locationPlaceholder
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.parentCtrl!.locationForSegue = self.locations![indexPath.row]
        self.parentCtrl!.performSegueWithIdentifier("locationDetail", sender: self)
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
