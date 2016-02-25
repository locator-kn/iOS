//
//  NameYourLocationViewController.swift
//  locator
//
//  Created by Timo Weiß on 25.02.16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class NameYourLocationViewController: UIViewController {
    
    var uiimage:UIImage!

    @IBOutlet weak var locationTitle: UITextField!
    override func viewDidLoad() {
        print("view did load")
        print(uiimage)
        locationTitle.attributedPlaceholder = NSAttributedString(string:"Name eintragen",
            attributes:[NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.4)])
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
