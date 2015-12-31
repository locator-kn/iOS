//
//  PictureImpression.swift
//  locator
//
//  Created by Michael Knoch on 31/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation

class pictures: AbstractImpression {
    
    let path:String
    
    init(id:String, date:NSDate, user:User, path:String) {
        
        self.path = path
        super.init(id: id, date: date, user: user)
        
    }
}