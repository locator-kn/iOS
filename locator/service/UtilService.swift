//
//  UtilService.swift
//  locator
//
//  Created by Michael Knoch on 21/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation
import UIKit

class UtilService {
 
    static func dateFromIso(iso:String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.dateFromString(iso)!
    }
    
    static func dataFromPath(path:String) -> NSData {
        return NSData(contentsOfURL: NSURL(string: path)!)!
    }
    
    static func roundImageView(imageview: UIImageView) -> UIImageView {
        imageview.layer.cornerRadius = imageview.frame.size.width / 2
        imageview.clipsToBounds = true
        
        imageview.layer.borderWidth = 3
        imageview.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
        
        
        return imageview
    }
    
    static func distanceBetweenCoords(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double {
        let R = 6371000.0; // metres
        let _lat1 = toRadian(lat1);
        let _lat2 = toRadian(lat2);
        let delta1 = toRadian(lat2-lat1);
        let delta2 = toRadian(lon2-lon1);
        
        let a = sin(delta1/2) * sin(delta1/2) + cos(_lat1) * cos(_lat2) * sin(delta2/2) * sin(delta2/2);
        let c = 2 * atan2(sqrt(a), sqrt(1-a));
        
        let d = R * c;
        return d
    }
    
    static func toRadian(num:Double) -> Double {
        return num * M_PI / 180;
    }
    
    static func getMyId() -> String {
        return NSUserDefaults.standardUserDefaults().stringForKey("me")!
    }
    
}