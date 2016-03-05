//
//  SettingsService.swift
//  locator
//
//  Created by Sergej Birklin on 04/03/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import Foundation
import PromiseKit
import FBSDKLoginKit

public class SettingsService {
    
    static func logout() {
        UserService.logout().then { result -> Void in
            NSUserDefaults.standardUserDefaults().removeObjectForKey("me")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("facebookUser")
            User.me = nil
            FBSDKLoginManager().logOut()
            AlertService.segueToLoginVC()
        }
    }
}