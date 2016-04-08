//
//  NameYourLocationViewController.swift
//  locator
//
//  Created by Timo Weiß on 25.02.16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit

class NameYourLocationViewController: UIViewController, UITextFieldDelegate {
    
    var uiimage:UIImage!
    var lat:Double!
    var long:Double!

    @IBOutlet weak var locationTitle: UITextField!
    
    let inputChecker = ValidateInputService()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cross"), style: .Plain, target: self, action: #selector(self.home))
        
        self.view.backgroundColor = COLORS.black
        self.title = "Bennene deine Location"
        
        locationTitle.attributedPlaceholder = NSAttributedString(string:"Name eintragen",
            attributes:[NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.4)])
        
        self.locationTitle.delegate = self
        
        
        locationTitle.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    func home() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(locationTitle: UITextField) -> Bool {   //delegate method
        if inputChecker.checkInput(locationTitle.text! ?? "", minLength: 3) {
            performSegueWithIdentifier("chooseCategories", sender: true)
            return true
        } else {
            return false
        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("going to leave")
        if (segue.identifier == "chooseCategories") {
            let controller = segue.destinationViewController as? AddCategoriesViewController
            controller!.locationTitle = self.locationTitle.text
            controller!.uiimage = self.uiimage
            controller!.lat = lat
            controller!.long = long
        }
    }

}
