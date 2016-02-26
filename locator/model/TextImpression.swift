//
//  TextImpression.swift
//  locator
//
//  Created by Michael Knoch on 07/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import Foundation

class TextImpression: AbstractImpression {
    var text: String
    
    init(date:String, userId:String, text: String) {
        self.text = text
        super.init(date: date, userId: userId)
    }
}