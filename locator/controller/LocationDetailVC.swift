//
//  ImpressionFeedVC.swift
//  locator
//
//  Created by Michael Knoch on 24/02/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit
import PromiseKit
import AVKit
import AVFoundation

class LocationDetailVC: UITableViewController {
    
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    var location: Location!
    var impressions: [AbstractImpression]?
    @IBOutlet weak var favorIcon: UIButton!
    let favoriteIcon = UIImage(named: "favorite_icon") as UIImage?
    let favoriteIconActive = UIImage(named: "favorite_icon_active") as UIImage?
    var headerCell: LocationDetailHeaderCell!
    var naviBack: UIImageView!
    
    var loader: LoadingView!
    
    var loaded = [String:UITableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "home"), style: .Plain, target: self, action: "home")
        self.loader = LoadingView(frame: self.view.frame)
        self.loader.backgroundColor = COLORS.blue
        self.view.addSubview(loader)
        
        naviBack = UIImageView(frame: CGRectMake(0, 0, 500, 90))
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = naviBack.frame
        gradient.colors = [UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 0.8) .CGColor, UIColor.clearColor().CGColor]
        gradient.locations = [0.0, 0.8]
        naviBack.layer.insertSublayer(gradient, atIndex: 0)
        
        view.addSubview(naviBack)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = COLORS.red
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

        self.clearsSelectionOnViewWillAppear = false
        tableView.estimatedRowHeight = 300.0
        
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func playVideo() {
        
        let myBaseUrl = "https://locator-app.com/api/v2/locations/impression/video/56b907022f08ffcd26f8c13a/impression.mov"
        if let url = NSURL(string: myBaseUrl) {

            self.player = AVPlayer(URL: url)
            self.playerController = AVPlayerViewController()
            self.playerController.player = self.player
            
            self.presentViewController(self.playerController, animated: true) {
                () -> Void in
                self.playerController.player?.play()
            }
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadData()
    }
    
    func loadData() {
        LocationService.locationById(location.id).then {
            location -> Void in
            
            self.loaded.removeAll()
            self.location = location
            self.title = self.location.title
            self.refreshHeader()
            self.loader.dismiss()
        
            UIView.animateWithDuration(0.5, animations: {
                self.headerCell.alpha = 1
            })
            
            ImpressionService.getImpressions(location.id).then {
                impressions -> Void in
                self.impressions = impressions
                self.location.favorites = impressions.count
                self.headerCell.impressionsCount.text = String(self.location.favorites)
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
            }
        }

    }
    
    func refresh(sender:AnyObject) {
        self.loadData()
    }
    
    func home() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0) {
            
            if (self.headerCell != nil) {
                return self.headerCell
            }
            
            let header = tableView.dequeueReusableCellWithIdentifier("headerCell") as! LocationDetailHeaderCell
            header.layoutMargins = UIEdgeInsetsZero;
            header.alpha = 0
            
            headerCell = header
            return header
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.impressions == nil {
            return 0
        }
        return self.impressions!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let impression = impressions![indexPath.row]
        if (self.loaded[impression.id] != nil) {
            return self.loaded[impression.id]!
        }
        
        if let imageImpression = impression as? ImageImpression {
            let cell = tableView.dequeueReusableCellWithIdentifier("imageImpression", forIndexPath: indexPath) as! ImageImpressionCell
          
            cell.date.text = imageImpression.getDate()
            UtilService.roundImageView(cell.userThumb)
            
            UserService.getUser(imageImpression.user.id!).then {
                result -> Void in
                print("user request")
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? ImageImpressionCell {
                    cellToUpdate.username.text = result.name
                }
                
                UtilService.dataFromCache(result.imagePathThumb!).then {
                    result -> Void in
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? ImageImpressionCell {
                        cellToUpdate.userThumb.image = UIImage(data: result)
                    }
                }
            }
            
            UtilService.dataFromCache(API.IMAGE_URL + imageImpression.imagePath).then {
                result -> Void in
                print("image impression request")
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? ImageImpressionCell {
                    cellToUpdate.imageBox.image = UIImage(data: result)
                }
            }
            
            self.loaded[impression.id] = tableView.cellForRowAtIndexPath(indexPath)
            return cell
            
        } else if let textImpression = impression as? TextImpression {
            let cell = tableView.dequeueReusableCellWithIdentifier("textImpression", forIndexPath: indexPath) as! TextImpressionCell
            
            cell.date.text = textImpression.getDate()
            UtilService.roundImageView(cell.userThumb)
            
            UserService.getUser(textImpression.user.id!).then {
                result -> Void in
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? TextImpressionCell {
                    cellToUpdate.username.text = result.name
                }
                
                UtilService.dataFromCache(result.imagePathThumb!).then {
                    result -> Void in
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? TextImpressionCell {
                        cellToUpdate.userThumb.image = UIImage(data: result)
                    }
                }
            }
            
            cell.textView.text = textImpression.text
            cell.textView.scrollEnabled = false
            let contentSize = cell.textView.sizeThatFits(cell.textView.bounds.size)
            var frame = cell.textView.frame
            frame.size.height = contentSize.height
            cell.textheight.constant = contentSize.height
            
            self.loaded[impression.id] = tableView.cellForRowAtIndexPath(indexPath)
            return cell
        
        } else if let videoImpression = impression as? VideoImpression {
            let cell = tableView.dequeueReusableCellWithIdentifier("videoimpression", forIndexPath: indexPath) as! VideoImpressionCell
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 430.0
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier("placeholderCell")
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if self.impressions != nil && self.impressions!.count == 0 {
            return 120.0
        }
        return 0
    }
    
    @IBAction func favorLocation(sender: UIButton) {
        
        if (!self.location.favored) {
            self.headerCell.favorIcon.setImage(self.favoriteIconActive, forState: .Normal)
        } else {
            self.headerCell.favorIcon.setImage(self.favoriteIcon, forState: .Normal)
        }
        
        LocationService.favLocation(location.id).then {
            favors,favor -> Void in
            
            self.location.favorites = favors
            self.location.favored = favor
            self.headerCell.favorCount.text = String(favors)
            
            }.error {
                err -> Void in
                print(err)
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        
        if (segue.identifier == "text") {
            let controller = segue.destinationViewController as! TextImpressionVC
            controller.locationId = self.location.id
        } else if (segue.identifier == "image") {
            let controller = segue.destinationViewController as! ImageImpressionVC
            controller.locationId = self.location.id
        } else if (segue.identifier == "video") {
            let controller = segue.destinationViewController as! VideoImpressionVC
            controller.locationId = self.location.id
        } else if (segue.identifier == "user") {
            let controller = segue.destinationViewController as! UserVC
            controller.user = self.location.user
        } else if (segue.identifier == "map") {
            let controller = segue.destinationViewController as! MapVC
            controller.locationsOfInterest[location.id] = location
        }
    }
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        naviBack.frame.origin.y = scrollView.contentOffset.y
    }
    
    func refreshHeader() {
        UtilService.dataFromCache(location.imagePathNormal).then {
            result -> Void in
            self.headerCell.locationImage.image = UIImage(data: result)
        }
        self.headerCell.username.setTitle(location.user.name! + "  \u{2E31}", forState: UIControlState.Normal)
        self.headerCell.favorCount.text = String(location.favorites)
        self.headerCell.impressionsCount.text = "0"
        self.headerCell.locationImage.image = UIImage(data: UtilService.dataFromPath(location.imagePathNormal))
        self.headerCell.city.text = location.city.title
        
    }

}
