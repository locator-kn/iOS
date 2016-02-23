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
        self.simpleAlert(currentView, title: "Ops", message: message)
    }
    
    static func simpleAlert(currentView: UIViewController, title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        currentView.presentViewController(alert, animated: true, completion: nil)
    }
    
}