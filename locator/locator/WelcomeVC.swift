//
//  ViewController.swift
//  locator
//
//  Created by Sergej Birklin on 09/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showLoginView(sender: UIButton) {
        //performSegueWithIdentifier("showLoginScreen", sender: self)
    }

}


