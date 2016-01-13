//
//  RegisterVC3.swift
//  locator
//
//  Created by Sergej Birklin on 05/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class RegisterVC3: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    let inputChecker = ValidateInputService()
    
    var name: String?
    var residence: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
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
        if inputChecker.checkEmailInput(textField.text! ?? "") == true {
            performSegueWithIdentifier("showRegisterVC4", sender: self)
            return true
        } else {
            alertFalseInput()
        }
        return false
    }
    
    func alertFalseInput() {
        let alert = UIAlertController(title: "Ups", message: "Falsche Email", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRegisterVC4"
        {
            if let destinationVC = segue.destinationViewController as? RegisterVC4 {
                destinationVC.name = self.name
                destinationVC.residence = self.residence
                destinationVC.email = self.emailTextField.text
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
