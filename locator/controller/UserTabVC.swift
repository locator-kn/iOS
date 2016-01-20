//
//  GenericTabBarVC.swift
//  locator
//
//  Created by Michael Knoch on 16/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class UserTabVC: UITabBarController {
    
    var locations:[Location]?
    var follower:[User]?
    var following:[User]?
    var user:User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // barbackgroundcolor
        UITabBar.appearance().barTintColor = UIColor(red: 38, green: 38, blue: 38)
        
        // font and fontsize
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName:UIFont(name: "Source Sans Pro", size: 16)!], forState: .Normal)
        
        // active item font color
        UITabBar.appearance().tintColor = UIColor(red: 192, green: 206, blue: 202)
        
        let locationList = self.viewControllers?[0] as! LocationListVC
        locationList.user = user
        
        let followerList = self.viewControllers?[1] as! UserListVC
        followerList.user = user
        followerList.showFollower = true
        
        let followedByList = self.viewControllers?[2] as! UserListVC
        followedByList.user = user
        followedByList.showFollower = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
