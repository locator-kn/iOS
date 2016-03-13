//
//  TextImpression.swift
//  locator
//
//  Created by Michael Knoch on 07/01/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import Foundation

class TextImpression: AbstractImpression {
    var text: String
    
    init(id:String, date:String, userId:String, text: String) {
        self.text = text
        super.init(id: id, date: date, userId: userId)
    }
}