//
//  RegisterVC4.swift
//  locator
//
//  Created by Sergej Birklin on 05/01/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import UIKit

class RegisterVC4: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    
    let inputChecker = ValidateInputService()
    
    var name: String?
    var residence: String?
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.becomeFirstResponder()
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func registerButtonClicked(sender: UIButton) {
        textFieldShouldReturn(passwordTextField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        if inputChecker.checkPasswordInput(textField.text! ?? "") == true {
            password = textField.text
            registerUser()
            return true
        } else {
            alertFalseInput()
            return false
        }
    }
    
    func alertFalseInput() {
        let alert = UIAlertController(title: "Ups", message: "Zu kurzes Passwort", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func alertFalseRegistration() {
        let alert = UIAlertController(title: "Ups", message: "Fehlerhafte Registrierung", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func registerUser() {
        UserService.register(email!, password: password!, name: name!, residence: residence!).then{
            response -> Void in
            print("User successfully registered")
            
            if let userId = response.id {
                NSUserDefaults.standardUserDefaults().setValue(userId, forKey: "me")
                User.me? = User(id: userId as String)
            }
            self.performSegueWithIdentifier("showRegisterVC5", sender: self)
            }.error { (error) -> Void in
                self.alertFalseRegistration()
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
