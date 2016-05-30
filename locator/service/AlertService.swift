//
//  AlertService.swift
//  locator
//
//  Created by Michael Knoch on 22/02/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import SwiftyJSON
import Alamofire

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
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: {action in segueToLoginVC()}))
            alertController.addAction(UIAlertAction(title: "Nö", style: UIAlertActionStyle.Default, handler: nil))
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
    
    static func openAppSettings(a: UIAlertAction) {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    static func menuActionSheet(ctrl: UIViewController) {
        
        var string: String = ""
        var id: String = ""
        
        if let _ctrl = ctrl as? LocationDetailVC {
            string = "Location "
            id = _ctrl.location.id
        } else if let _ctrl = ctrl as? UserVC,
            _id = _ctrl.user.id {
            
            id = _id
            string = "User "
        }
        
        let optionMenu = UIAlertController(title: nil, message: "Menü", preferredStyle: .ActionSheet)
        
        let reportAction = UIAlertAction(title: string + "Melden", style: .Destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            self.simpleAlert(ctrl, title: "Danke", message: "Wir kümmen uns darum")
            
            let reportString = string + ": " + id
            self.report(reportString)
            print("Report: " + reportString)
            
        })
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(reportAction)
        optionMenu.addAction(cancelAction)
        
        ctrl.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    static func report(reportString: String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            Alamofire.request(.POST, API.BASE_URL + "/report", parameters: ["report": reportString])
                .validate()
                .responseJSON {
                    response in
                    
                    switch response.result {
                    case .Success:
                        fulfill(true)
                    case .Failure(let error):
                        reject(error)
                    }
            }
        }
    }

}