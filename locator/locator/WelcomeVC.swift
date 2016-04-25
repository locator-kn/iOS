//
//  ViewController.swift
//  locator
//
//  Created by Sergej Birklin on 09/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import UIKit
import BWWalkthrough

class WelcomeVC: UIViewController, BWWalkthroughViewControllerDelegate {
    
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var top_text: NSLayoutConstraint!
    @IBOutlet weak var top_button: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Willkommen bei"
        // Do any additional setup after loading the view, typically from a nib.
        
        if (UIScreen.mainScreen().bounds.size.height == 480) {
            self.top.constant = 5
            self.top_button.constant = 10
        }
        
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let walkthrough = stb.instantiateViewControllerWithIdentifier("master") as! OnboardMainVC
        let page_one = stb.instantiateViewControllerWithIdentifier("onboard_1") as UIViewController
        let page_two = stb.instantiateViewControllerWithIdentifier("onboard_2") as UIViewController
        let page_three = stb.instantiateViewControllerWithIdentifier("onboard_3") as UIViewController
        let page_four = stb.instantiateViewControllerWithIdentifier("onboard_4") as UIViewController
        let page_five = stb.instantiateViewControllerWithIdentifier("onboard_5") as UIViewController
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.addViewController(page_one)
        walkthrough.addViewController(page_two)
        walkthrough.addViewController(page_three)
        walkthrough.addViewController(page_four)
        walkthrough.addViewController(page_five)
        self.navigationController?.presentViewController(walkthrough, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func walkthroughPageDidChange(pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


