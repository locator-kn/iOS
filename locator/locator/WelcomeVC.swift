//
//  ViewController.swift
//  locator
//
//  Created by Sergej Birklin on 09/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import UIKit
import BWWalkthrough

class WelcomeVC: UIViewController {
    
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
        
        BoardingService.showBoarding(self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


