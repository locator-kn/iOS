//
//  TextImpressionVC.swift
//  locator
//
//  Created by Michael Knoch on 06/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class TextImpressionVC: UIViewController, UITextFieldDelegate {
    
    var locationId:String!
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self //set delegate to textfile
        print("open textimpression for location: " + self.locationId)

        // Do any additional setup after loading the view.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        self.closeModal(self)
        
        if textField.text?.characters.count > 3 {
            ImpressionService.addTextImpression(self.locationId, data: textField.text!).then {
                result -> Void in
                print("post textimpression success")
            }.error {
                err -> Void in
                print("textimpression error")
                print(err)
            }
        }
        
        return true
    }

}
