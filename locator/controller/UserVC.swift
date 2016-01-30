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
    
    @IBOutlet weak var locationsCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var sendMessageButton: UIButton!
    
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
        
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func updateView() {
    
        UtilService.dataFromCache(self.user.imagePathNormal!).then {
            result -> Void in
            self.profileImage.image = UIImage(data: result)
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
            self.profileImage.clipsToBounds = true
        }
        self.userName.text = self.user.name
        self.locationsCount.text = "\(self.user.locationCount!)"
        self.followersCount.text = "\(self.user.followerCount!)"
    }
    
    @IBAction func followButton(sender: UIButton) {
        self.user.follow().then {
            result -> Void in
            print("Follow" + self.user.id!)
            
            let origImage = UIImage(named: "follow");
            let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.followButton.setImage(tintedImage, forState: .Normal)
            self.followButton.tintColor = UIColor.redColor()
        }
    }
    
    @IBAction func sendMessageButton(sender: UIButton) {
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
