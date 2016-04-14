//
//  UserVC.swift
//  locator
//
//  Created by Michael Knoch on 16/01/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit

class UserVC: UIViewController {

    var tabVC:UserTabVC?
    
    var user:User!
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
    let settingsIcon = UIImage(named: "settings") as UIImage?
    var me = false
    
    var loader: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loader = LoadingView(frame: self.view.frame)
        self.loader.backgroundColor = COLORS.red
        profileImage = UtilService.roundImageView(profileImage, borderWidth: 4)
        self.view.addSubview(loader)
        
        print("User with ID: " + self.user!.id!)
        TrackingService.sharedInstance.trackEvent("Userview | load")
        
        // fetch user information
        UserService.getUser(user.id!)
            .then {
                result -> Void in
                self.user = result
                
                // catch this edgecase
                if (User.me != nil && User.me!.following == nil) {
                    UserService.getUser(User.me!.id!).then {
                        result -> Void in
                        User.me = result
                        self.updateView()
                    }
                } else {
                    self.updateView()
                }
                
            }
            .error {
                error -> Void in
                print(error)
        }
        
        if (self.user.id == User.me?.id) {
            me = true
            self.followButton.setImage(self.settingsIcon, forState: .Normal)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "home"), style: .Plain, target: self, action: #selector(self.home))
        
        let overlay: CAGradientLayer = CAGradientLayer()
        overlay.frame = gradient.frame
        overlay.colors = [UIColor.clearColor().CGColor, UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 0.8).CGColor]
        overlay.locations = [0.0, 1]
        gradient.layer.insertSublayer(overlay, atIndex: 0)
        
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
    
    override func viewDidLayoutSubviews() {
        UtilService.roundImageView(self.profileImage)
    }
    
    func updateView() {
        UtilService.dataFromCache(self.user.imagePathNormal!).then {
            result -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.profileImage.image = UIImage(data: result)
                self.profileImage.layoutSubviews()
            })
            
        }
        self.title = self.user.name
        self.locationsCount.text = "\(self.user.locationCount!)"
        self.followersCount.text = "\(self.user.followerCount!)"
        self.loader.dismiss()
        
        if (User.me?.following != nil && User.me!.following!.contains(self.user.id!)) {
            self.user.mefollowing = true
            self.followButton.setImage(self.followActiveIcon, forState: .Normal)
        }

    }
    
    @IBAction func followButton(sender: UIButton) {
        if !AlertService.validateLoggedUser(self) {
            return
        }
        
        if self.me {
            self.performSegueWithIdentifier("settings", sender: self)
            return
        }
        
        if !self.user.mefollowing {
            self.followButton.setImage(self.followActiveIcon, forState: .Normal)
            self.user.follow()
        } else {
            self.followButton.setImage(self.followIcon, forState: .Normal)
            self.user.unfollow()
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
