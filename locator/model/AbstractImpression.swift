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
    
    init(date:String, userId:String) {
        self.date = UtilService.dateFromIso(date)
        self.user = User(id: userId)
    }
    
    init(date:NSDate, user:User) {
        self.date = date
        self.user = user
    }
    
    func getDate() -> String {
        return UtilService.getReadableDateString(self.date)
    }
    
}