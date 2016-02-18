//
//  LoginVC.swift
//  locator
//
//  Created by Sergej Birklin on 09/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginVC: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginFacebookButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    let borderWidth = 2.0
    let borderColor = UIColor.whiteColor().CGColor
    let borderCornerRadius = 15.0
    
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    let facebookManager = FBSDKLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addTapped")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cross"), style: .Plain, target: self, action: "addTapped")
        
        setButtons()
        // Do any additional setup after loading the view.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setButtons() {
        loginButton.layer.borderWidth = CGFloat(borderWidth)
        loginButton.layer.borderColor = borderColor
        loginButton.layer.cornerRadius = CGFloat(borderCornerRadius)
        
        loginFacebookButton.layer.borderWidth = CGFloat(borderWidth)
        loginFacebookButton.layer.borderColor = borderColor
        loginFacebookButton.layer.cornerRadius = CGFloat(borderCornerRadius)
        
        registerButton.layer.borderWidth = CGFloat(borderWidth)
        registerButton.layer.borderColor = borderColor
        registerButton.layer.cornerRadius = CGFloat(borderCornerRadius)
    }

    @IBAction func loginButtonPressed(sender: UIButton) {
    }
    
    @IBAction func loginFacebookButtonPressed(sender: UIButton) {
        
        facebookManager.logInWithReadPermissions(facebookReadPermissions, fromViewController: self) { (result, error) -> Void in
            if (error != nil) {
                print("Process error")
            } else if (result.isCancelled) {
                print("Cancelled")
            } else {
                print("Logged in")
                self.returnUserData()
            }
        }
    }
    
    @IBAction func registerButtonPressed(sender: UIButton) {
    }
    
    @IBAction func crossButtonPressed(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name,email,gender,id"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result .valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
            }
        })
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
