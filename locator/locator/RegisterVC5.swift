//
//  RegisterVC5.swift
//  locator
//
//  Created by Sergej Birklin on 05/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import UIKit

class RegisterVC5: UIViewController {
    
    @IBOutlet weak var profilImageButton: UIButton!
    
    var name: String?
    var residence: String?
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func profilImageButtonPressed(sender: UIButton) {
        
    }
    
    @IBAction func registerButtonPressed(sender: UIButton) {
        registerUser()
    }
    
    func registerUser() {
        UserService.register(email!, password: password!, name: name!, residence: residence!).then{
            response -> Void in
            print("User successfully registered")
            self.performSegueWithIdentifier("showWelcomeRegisteredView", sender: self)
            
            }.error { (error) -> Void in
                self.alertFalseInput()
        }
    }
    
    func alertFalseInput() {
        let alert = UIAlertController(title: "Ups", message: "Fehlerhafte Registrierung", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
