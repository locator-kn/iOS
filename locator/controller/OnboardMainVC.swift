//
//  OnboardMainVC.swift
//  locator
//
//  Created by Michael Knoch on 25/04/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit
import BWWalkthrough

class OnboardMainVC: BWWalkthroughViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction internal override func close(sender: AnyObject){
        close()
    }
    
    func close() {
        dismissViewControllerAnimated(true) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "onboarded")
        }
    }

}
