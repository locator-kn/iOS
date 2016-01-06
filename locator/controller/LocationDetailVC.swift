//
//  LocationDetailVC.swift
//  locator
//
//  Created by Michael Knoch on 20/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import UIKit

class LocationDetailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationDescription: UITextView!
    @IBOutlet weak var favorIcon: UIButton!
    @IBOutlet weak var opacity: UIImageView!
    var location:Location!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        LocationService.locationById(location.id).then {
            result -> Void in

            let path = result.imagePath;
            let url  = NSURL(string: path),

            data = NSData(contentsOfURL: url!)
            self.imageView.image = UIImage(data: data!)
            self.locationTitle.text = result.title
            self.locationDescription.text = result.description
            
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = self.imageView.frame
            gradient.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
            gradient.locations = [0.0, 0.5, 1]
            self.imageView.layer.insertSublayer(gradient, atIndex: 0)
            
        }.error {
            err -> Void in
            print(err)
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
