//
//  EmailLoginVC2.swift
//  locator
//
//  Created by Sergej Birklin on 14/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import UIKit
import Alamofire

class EmailLoginVC2: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    var email:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(email)
        passwordTextField.delegate = self
        passwordTextField.becomeFirstResponder()
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
    
    @IBAction func passwordTextFieldDidEndOnExit(sender: UITextField) {
        UserService.login(email, password: passwordTextField.text!).then {
            user -> Void in
            print("Login Success: " + user.name)
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
