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
    let userId: String
    var user: User!
    
    init(id:String, date:String, userId: String) {
        self.id = id
        self.date = UtilService.dateFromIso(date)
        self.userId = userId
    }
    
    func getDate() -> String {
        return UtilService.getReadableDateString(self.date)
    }
    
}