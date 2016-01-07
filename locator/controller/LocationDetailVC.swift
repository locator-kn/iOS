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
    
    let favoriteIcon = UIImage(named: "favorite_icon") as UIImage?
    let favoriteIconActive = UIImage(named: "favorite_icon_active") as UIImage?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        LocationService.locationById(location.id).then {
            result -> Void in

            self.imageView.image = UIImage(data: UtilService.dataFromPath(result.imagePath))
            self.locationTitle.text = result.title
            self.locationDescription.text = result.description
            
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = self.imageView.frame
            gradient.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
            gradient.locations = [0.0, 0.5, 1]
            self.imageView.layer.insertSublayer(gradient, atIndex: 0)
            
            if (result.favored == true) {
                self.favorIcon.setImage(self.favoriteIconActive, forState: .Normal)
            }
            
        }.error {
            err -> Void in
            print(err)
        }
        
        LocationService.getStream(location.id).then {
            result -> Void in
            
            print(result)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
