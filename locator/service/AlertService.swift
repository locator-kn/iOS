//
//  AlertService.swift
//  locator
//
//  Created by Michael Knoch on 22/02/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
        
    static func simpleAlert(currentView: UIViewController, message: String) {
        self.simpleAlert(currentView, title: "Hoppla", message: message)
    }
    
    static func simpleAlert(currentView: UIViewController, title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        currentView.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func validateLoggedUser(currentView: UIViewController) -> Bool {
        
        if User.me != nil {
            return true
        } else {
            let alertController = UIAlertController(title: "Hoppla", message: "Du musst eingeloggt sein", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {action in segueToLoginVC()}))
            alertController.addAction(UIAlertAction(title: "Nö", style: UIAlertActionStyle.Cancel, handler: nil))
            currentView.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
    }
    
    static func segueToLoginVC() {
        dispatch_async(dispatch_get_main_queue(), {
            
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = mainStoryBoard.instantiateViewControllerWithIdentifier("firstnavi") as! MainNavigationVC
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = loginVC
        })
    }

}