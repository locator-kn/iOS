//
//  NameYourLocationViewController.swift
//  locator
//
//  Created by Timo Weiß on 25.02.16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class NameYourLocationViewController: UIViewController, UITextFieldDelegate {
    
    var uiimage:UIImage!

    @IBOutlet weak var locationTitle: UITextField!
    
    let inputChecker = ValidateInputService()

    
    override func viewDidLoad() {
        
        self.title = "Bennene deine Location"
        
        locationTitle.attributedPlaceholder = NSAttributedString(string:"Name eintragen",
            attributes:[NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.4)])
        
        self.locationTitle.delegate = self
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(locationTitle: UITextField) -> Bool {   //delegate method
        if inputChecker.checkInput(locationTitle.text! ?? "", minLength: 3) {
            //performSegueWithIdentifier("showRegisterVC3", sender: self)
            print("whoop whoop")
            
            
            performSegueWithIdentifier("chooseCategories", sender: true)
            return true
        } else {
            print("nonono")
            return false
        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("going to leave")
        if (segue.identifier == "chooseCategories") {
            //let controller = segue.destinationViewController as! AddCategoriesViewController
                let controller = segue.destinationViewController as? AddCategoriesViewController
                controller!.locationTitle = self.locationTitle.text
                controller!.uiimage = self.uiimage
            
            
            
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
