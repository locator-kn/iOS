//
//  TextImpressionVC.swift
//  locator
//
//  Created by Michael Knoch on 06/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class TextImpressionVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self //set delegate to textfile

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        self.closeModal(self)
        print("close")
        return true
    }

}
