//
//  MainNavigationVC.swift
//  locator
//
//  Created by Michael Knoch on 25/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class MainNavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        styleNaviBar()
        
        // if a user is set in defaults, redirect to dashboard
        if (NSUserDefaults.standardUserDefaults().stringForKey("me") != nil) {
            UserService.protected().then {
                result -> Void in
                print("Statuscode Protected", result)
                if (result != 401) {
                    self.redirectToDashboard()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func redirectToDashboard() {
        self.performSegueWithIdentifier("dashboard", sender: self)
    }
    
    func styleNaviBar() {
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.translucent = true
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationBar.backIndicatorImage = UIImage(named: "back")
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        
        let font = UIFont(name: "SourceSansPro-Bold", size: 18)!
        self.navigationBar.titleTextAttributes = [ NSFontAttributeName: font]
        
        // hide back button text my moving out of view
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        let barbuttonFont = UIFont(name: "Helvetica-Neue", size: 0.1) ?? UIFont.systemFontOfSize(0.1)
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: barbuttonFont, NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Normal)
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
