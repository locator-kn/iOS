//
//  EmailLoginVC.swift
//  locator
//
//  Created by Sergej Birklin on 14/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import UIKit
import PromiseKit

class EmailLoginVC1: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    let inputChecker = ValidateInputService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cross"), style: .Plain, target: self, action: "close")
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
        let alert = UIAlertController(title: "Ups", message: "Bitte überprüfe deine Email-Adresse!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEmailLoginVC2" {
            if let destinationVC = segue.destinationViewController as? EmailLoginVC2{
                destinationVC.email = emailTextField.text
            }
        }
    }
    
    func close() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func passwordForget(sender: UIButton) {
        if emailTextField.text == nil {
            AlertService.simpleAlert(self, message: "Bitte gebe deine Email Adresse ein!")
        } else if inputChecker.checkEmailInput(emailTextField.text!) == false {
            AlertService.simpleAlert(self, message: "Bitte gebe eine korrekte Email Adresse ein!")
        } else {
            UserService.resetPassword(emailTextField.text!).then({ response -> Void in
                if response == true {
                    let alert = UIAlertController(title: "Super", message: "Ein neues Passwort wurde an die angegebene Emailadresse gesendet!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    AlertService.simpleAlert(self, message: "Deine Passwort konnte leider nicht geändert werden")
                }
            })
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
