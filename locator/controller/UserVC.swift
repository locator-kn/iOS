//
//  UserVC.swift
//  locator
//
//  Created by Michael Knoch on 16/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class UserVC: UIViewController {

    var tabVC:UserTabVC?
    
    var user:User = User(id: "569e4a83a6e5bb503b838306")
    var userLocations: [Location]?
    
    var locationForSegue: Location?
    var userForSegue: User?
    
    @IBOutlet weak var locationsCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var gradient: UIImageView!
    
    let followIcon = UIImage(named: "follow") as UIImage?
    let followActiveIcon = UIImage(named: "follow_active") as UIImage?
    
    override func viewDidLoad() {
        print("User with ID: " + self.user.id!)
        
        // fetch user information
        UserService.getUser(user.id!)
            .then {
                result -> Void in
                self.user = result
                self.updateView()
            }
            .error {
                error -> Void in
                print(error)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "home"), style: .Plain, target: self, action: "home")
        
        let overlay: CAGradientLayer = CAGradientLayer()
        overlay.frame = gradient.frame
        overlay.colors = [UIColor.clearColor().CGColor, UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 0.8).CGColor]
        overlay.locations = [0.0, 1]
        gradient.layer.insertSublayer(overlay, atIndex: 0)
        
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func home() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func updateView() {
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.clipsToBounds = true
        UtilService.dataFromCache(self.user.imagePathNormal!).then {
            result -> Void in
            self.profileImage.image = UIImage(data: result)
        }
        self.title = self.user.name
        self.locationsCount.text = "\(self.user.locationCount!)"
        self.followersCount.text = "\(self.user.followerCount!)"
        
        if (User.me!.following!.contains(self.user.id!)) {
            self.followButton.setImage(self.followActiveIcon, forState: .Normal)
        }

    }
    
    @IBAction func followButton(sender: UIButton) {
        
        self.followButton.setImage(self.followActiveIcon, forState: .Normal)
        self.user.follow().then {
            result -> Void in
            print("Follow" + self.user.id!)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "tabBarVC") {
            self.tabVC = segue.destinationViewController as? UserTabVC
            self.tabVC!.user = self.user
        }
    }

}
