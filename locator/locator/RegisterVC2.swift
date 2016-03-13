//
//  RegisterVC2.swift
//  locator
//
//  Created by Sergej Birklin on 05/01/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit

class RegisterVC2: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var residenceTextField: UITextField!
    
    let inputChecker = ValidateInputService()
    
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        residenceTextField.becomeFirstResponder()
        residenceTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func backButtonPressed(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func crossButtonPressed(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        if inputChecker.checkInput(textField.text! ?? "", minLength: 3) {
            performSegueWithIdentifier("showRegisterVC3", sender: self)
            return true
        } else {
            alertFalseInput()
            return false
        }
    }
    
    func alertFalseInput() {
        let alert = UIAlertController(title: "Ups", message: "Bitte überprüfe deine Stadt", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRegisterVC3"
        {
            if let destinationVC = segue.destinationViewController as? RegisterVC3 {
                destinationVC.name = self.name
                destinationVC.residence = residenceTextField.text
            }
        }
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
