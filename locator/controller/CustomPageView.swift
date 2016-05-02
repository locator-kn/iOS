//
//  CustomPageView.swift
//  locator
//
//  Created by Michael Knoch on 02/05/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit
import BWWalkthrough

class CustomPageView: BWWalkthroughPageViewController {

    var root: OnboardMainVC?
    
    @IBOutlet weak var button: UIButton?
    @IBOutlet weak var buttonbottom: NSLayoutConstraint?
    
    @IBAction func go(sender: UIButton) {
        root?.close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let btn = button {
            btn.backgroundColor = COLORS.red
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
