//
//  AbstractImpression.swift
//  locator
//
//  Created by Michael Knoch on 31/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation

class AbstractImpression {
    
    let date:NSDate
    let user:User
    let data:NSData
    
    init(date:String, userId:String, data:NSData) {
        self.date = UtilService.dateFromIso(date)
        self.user = User(id: userId)
        self.data = data
    }
    
    init(date:NSDate, user:User, data:NSData) {
        self.date = date
        self.user = user
        self.data = data
    }
    
    func getData() -> AnyObject {
        return data
    }
    
}