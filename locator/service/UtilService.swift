//
//  UtilService.swift
//  locator
//
//  Created by Michael Knoch on 21/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation

class UtilService {
 
    static func dateFromIso(iso:String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.dateFromString(iso)!
    }
    
}