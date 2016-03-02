//
//  VideoImpression.swift
//  locator
//
//  Created by Michael Knoch on 31/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation

class VideoImpression:AbstractImpression {
    var videoPath: String
    var imageThumb: String?
    
    init(id:String, date:String, userId:String, videoPath: String) {
        self.videoPath = videoPath
        super.init(id: id, date: date, userId: userId)
    }
    
}