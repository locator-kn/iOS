//
//  SecondNavigationVC.swift
//  locator
//
//  Created by Michael Knoch on 28/02/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit

class SecondNavigationVC: AbstractNavigationVC {

    
    override func viewDidLoad() {
        
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
            window.rootViewController = self
        }
        
        self.styleNaviBar()
        
        // if a user is set in defaults, redirect to dashboard
        if (NSUserDefaults.standardUserDefaults().stringForKey("me") != nil) {
            UserService.protected().then {
                result -> Void in
                User.me = User(id: NSUserDefaults.standardUserDefaults().stringForKey("me")!)
                print("Statuscode Protected", result)
                if (result == 401 || result == 400) {
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let secondnavi = mainStoryboard.instantiateViewControllerWithIdentifier("firstnavi") as! MainNavigationVC
                    let window = UIApplication.sharedApplication().delegate!.window!
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("me")
                    window!.rootViewController = secondnavi
                    window!.makeKeyAndVisible()
                }
            }
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
