//
//  AbstractNavigationCtrl.swift
//  locator
//
//  Created by Michael Knoch on 28/02/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit

class AbstractNavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleNaviBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

}
