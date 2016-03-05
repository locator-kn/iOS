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
    @IBOutlet weak var top: NSLayoutConstraint!
    
    let borderWidth = 2.0
    let borderColor = UIColor.whiteColor().CGColor
    let borderCornerRadius = 15.0
    
    let facebookReadPermissions = ["public_profile", "email"]
    let facebookManager = FBSDKLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cross"), style: .Plain, target: self, action: "close")
        
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
    
    func close() {
        self.navigationController?.popToRootViewControllerAnimated(true)
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
        
        if (UIScreen.mainScreen().bounds.size.height == 480) {
            self.top.constant = 5
        }
    }
    
    @IBAction func loginFacebookButtonPressed(sender: UIButton) {
        
        facebookManager.logInWithReadPermissions(facebookReadPermissions, fromViewController: self) { (result, error) -> Void in
            if (error != nil) {
                print("Process error")
            } else if (result.isCancelled) {
                print("Cancelled")
            } else {
                print("Logged in")
                self.loginFacebookUser()
                self.returnUserData()
            }
        }
    }
    
    @IBAction func registerButtonPressed(sender: UIButton) {}
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                _ = result.valueForKey("id") as! NSString
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print(accessToken)
            }
        })
    }
    
    func showDashboard() {
        dispatch_async(dispatch_get_main_queue(), {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = mainStoryBoard.instantiateViewControllerWithIdentifier("secondnavi") as! SecondNavigationVC
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = loginVC
        })
    }
    
    func loginFacebookUser() {
        let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
        UserService.facebookLogin(accessToken).then {
            result -> Void in
            print(result)
            User.me = result
            if result.id != nil {
                NSUserDefaults.standardUserDefaults().setValue(result.id, forKey: "me")
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "facebookUser")
            }
            }.then {
                self.showDashboard()
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
