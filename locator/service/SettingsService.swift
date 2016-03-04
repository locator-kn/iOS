//
//  SettingsService.swift
//  locator
//
//  Created by Sergej Birklin on 04/03/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import Foundation

public class SettingsService {
    
    static func logout() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("me")
    }
}