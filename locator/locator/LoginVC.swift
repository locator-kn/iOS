//
//  LoginVC.swift
//  locator
//
//  Created by Sergej Birklin on 09/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginFacebookButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    let borderWidth = 2.0
    let borderColor = UIColor.whiteColor().CGColor
    let borderCornerRadius = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    @IBAction func registerButtonPressed(sender: UIButton) {
    }
    
    @IBAction func crossButtonPressed(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
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
