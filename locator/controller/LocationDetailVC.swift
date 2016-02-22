//
//  LocationDetailVC.swift
//  locator
//
//  Created by Michael Knoch on 20/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import UIKit

class LocationDetailVC: UIViewController {
    
    var location:Location!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationDescription: UITextView!
    @IBOutlet weak var favorIcon: UIButton!
    @IBOutlet weak var opacity: UIImageView!
    @IBOutlet weak var userName: UIButton!
    @IBOutlet weak var cityTitle: UILabel!
    
    let favoriteIcon = UIImage(named: "favorite_icon") as UIImage?
    let favoriteIconActive = UIImage(named: "favorite_icon_active") as UIImage?
    
    @IBAction func back(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(location.id)

        LocationService.locationById(location.id).then {
            result -> Void in
            
            self.location = result

            UtilService.dataFromCache(self.location.imagePathNormal).then {
                result -> Void in
                self.imageView.image = UIImage(data: result)
            }
            
            self.locationTitle.text = self.location.title
            self.locationDescription.text = self.location.description
     
            self.userName.setTitle(result.user.name, forState: UIControlState.Normal)
            self.cityTitle.text = result.city.title
            
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = self.imageView.frame
            gradient.colors = [UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 0.8) .CGColor, UIColor.clearColor().CGColor]
            gradient.locations = [0.0, 0.5, 1]
            self.imageView.layer.insertSublayer(gradient, atIndex: 0)
            
            if (self.location.favored == true) {
                self.favorIcon.setImage(self.favoriteIconActive, forState: .Normal)
            }
            
        }.error {
            err -> Void in
            print(err)
        }
        
        ImpressionService.getImpressions(location.id).then {
            result -> Void in
            
            self.location.stream = result
            
            print(result)
            for item in result {
                print(item.getData())
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favorLocation(sender: UIButton) {
        LocationService.favLocation(location.id).then {
            favors,favor -> Void in
            
            self.location.favorites = favors
            self.location.favored = favor
            
            if (favor) {
                self.favorIcon.setImage(self.favoriteIconActive, forState: .Normal)
            } else {
                self.favorIcon.setImage(self.favoriteIcon, forState: .Normal)
            }
            
            }.error {
                err -> Void in
                print(err)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        if (segue.identifier == "textImpression") {
            let controller = segue.destinationViewController as! TextImpressionVC
            controller.locationId = self.location.id
        } else if (segue.identifier == "imageImpression") {
            let controller = segue.destinationViewController as! ImageImpressionVC
            controller.locationId = self.location.id
        } else if (segue.identifier == "user") {
            let controller = segue.destinationViewController as! UserVC
            controller.user = self.location.user
        } else if (segue.identifier == "map") {
            let controller = segue.destinationViewController as! MapVC
            controller.locationsOfInterest[location.id] = location
        }
    }

}
