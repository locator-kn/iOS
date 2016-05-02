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

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonbottom: NSLayoutConstraint!
    @IBAction func go(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        button.backgroundColor = COLORS.red
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
