//
//  AbstractImpression.swift
//  locator
//
//  Created by Michael Knoch on 31/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation

class AbstractImpression {
    
    let id:String
    let date:NSDate
    let user:User
    let data:NSData
    
    init(id:String, date:NSDate, user:User, path:String) {
        self.id = id
        self.date = date
        self.user = user
        self.data = NSData(contentsOfURL: NSURL(string: path)!)!
    }
    
}