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
    let inputValidation = ValidateInputService()
    var loader: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cross"), style: .Plain, target: self, action: "close")
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
        
        if inputValidation.checkPasswordInput(sender.text!) == true {
            
            self.loader = LoadingView(frame: self.view.frame)
            self.loader.backgroundColor = COLORS.red
            self.view.addSubview(loader)
            
            UserService.login(email, password: passwordTextField.text!).then {
                user -> Void in
                print("Login Success: " + user.name!)
                User.setMe(user)
                print(User.getMe().name)
                NSUserDefaults.standardUserDefaults().setValue(User.getMe().id, forKey: "me")
                self.performSegueWithIdentifier("dashboard", sender: self)
            }.always {
                self.loader.dismiss()
            }.error {
                err -> Void in
                print("Login Error")
                print(err)
                self.showError()
            }
        
        } else {
            self.showError()
        }
    }
    
    func showError() {
        AlertService.simpleAlert(self, title: "Ups", message: "Überprüfe deine Login Daten!")
    }
    
    func close() {
        self.navigationController?.popToRootViewControllerAnimated(true)
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
