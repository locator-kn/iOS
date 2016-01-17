//
//  GenericTabBarVC.swift
//  locator
//
//  Created by Michael Knoch on 16/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class UserTabVC: UIViewController {
    
    var locations:[Location]?
    var follower:[User]?
    var following:[User]?

    @IBOutlet weak var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // barbackgroundcolor
        //UITabBar.appearance().barTintColor = UIColor.clearColor()
        

        // set new blank images as background and shadow, great hack, like this.
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        
        // font and fontsize
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName:UIFont(name: "Source Sans Pro", size: 16)!], forState: .Normal)
        
        
        
        /*let followerTab = self.tabBarController?.viewControllers![1]
        let followingTab = self.tabBarController?.viewControllers![2]*/
        
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
