//
//  BoardingService.swift
//  locator
//
//  Created by Michael Knoch on 25/04/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import Foundation
import UIKit

class BoardingService {
    
    static func showBoarding(ctrl: UIViewController) {
        if !NSUserDefaults.standardUserDefaults().boolForKey("onboarded") {
            let stb = UIStoryboard(name: "Main", bundle: nil)
            let walkthrough = stb.instantiateViewControllerWithIdentifier("master") as! OnboardMainVC
            let page_one = stb.instantiateViewControllerWithIdentifier("onboard_1") as UIViewController
            let page_two = stb.instantiateViewControllerWithIdentifier("onboard_2") as UIViewController
            let page_three = stb.instantiateViewControllerWithIdentifier("onboard_3") as UIViewController
            let page_four = stb.instantiateViewControllerWithIdentifier("onboard_4") as UIViewController
            let page_five = stb.instantiateViewControllerWithIdentifier("onboard_5") as UIViewController
            
            // Attach the pages to the master
            walkthrough.addViewController(page_one)
            walkthrough.addViewController(page_two)
            walkthrough.addViewController(page_three)
            walkthrough.addViewController(page_four)
            walkthrough.addViewController(page_five)
            ctrl.navigationController?.presentViewController(walkthrough, animated: true, completion: nil)
        }
    }
    
}