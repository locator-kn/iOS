//
//  EmailLoginVC.swift
//  locator
//
//  Created by Sergej Birklin on 14/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import UIKit

class EmailLoginVC1: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    let inputChecker = ValidateInputService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func crossButtonPressed(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        if (inputChecker.checkEmailInput(textField.text!) == true) {
            performSegueWithIdentifier("showEmailLoginVC2", sender: self)
            return true
        } else {
            alertFalseInput()
        }
        return false
    }
    
    func alertFalseInput() {
        let alert = UIAlertController(title: "Ups", message: "Bitte überprüfe deine Email-Adresse", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEmailLoginVC2"
        {
            if let destinationVC = segue.destinationViewController as? EmailLoginVC2{
                destinationVC.email = emailTextField.text
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
