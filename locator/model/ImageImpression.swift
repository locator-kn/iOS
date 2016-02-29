//
//  PictureImpression.swift
//  locator
//
//  Created by Michael Knoch on 31/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation

class ImageImpression: AbstractImpression {
    var imagePath: String
    
    init(id:String, date:String, userId:String, imagePath: String) {
        self.imagePath = imagePath
        super.init(id: id, date: date, userId: userId)
    }
}