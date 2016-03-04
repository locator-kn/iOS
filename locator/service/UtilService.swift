//
//  UtilService.swift
//  locator
//
//  Created by Michael Knoch on 21/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation
import UIKit
import Haneke
import PromiseKit

class UtilService {
 
    static func dateFromIso(iso:String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.dateFromString(iso)!
    }
    
    static func getReadableDateString(date: NSDate) -> String {
        
        let today = NSDate()
        let todayCalendar = NSCalendar.currentCalendar()
        let todayComponents = todayCalendar.components([.Day , .Month , .Year], fromDate: today)
        let todayYear =  todayComponents.year
        let todayMonth = todayComponents.month
        let todayDay = todayComponents.day
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        
        if (todayYear == year && todayMonth == month && todayDay == day) {
            return "Heute"
        } else if (todayYear == year && todayMonth == month && todayDay == day + 1) {
            return "Gestern"
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let readableDate = formatter.stringFromDate(date)
        return readableDate
    }
    
    static func dataFromPath(path:String) -> NSData {
        return NSData(contentsOfURL: NSURL(string: path)!)!
    }
    
    static func dataFromCache(path:String) -> Promise<NSData> {
        return Promise { fulfill, reject in
            
            if (path != "") {
                let cache = Shared.dataCache
                cache.fetch(URL: NSURL(string: path)!).onSuccess { data in
                    fulfill(data)
                }
            } else {
                reject(NSError(domain: "Imagecache", code: 404, userInfo: nil))
            }
        }
    }
    
    static func trimPushToken(deviceToken:NSData) -> String {
        var token = NSString(format: "%@", deviceToken)
        token = token.stringByReplacingOccurrencesOfString("<",withString: "")
        token = token.stringByReplacingOccurrencesOfString(">",withString: "")
        return token.stringByReplacingOccurrencesOfString(" ", withString: "")
    }
    
    static func roundImageView(imageView: UIImageView) -> UIImageView {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        return imageView
    }
    
    static func roundImageView(var imageView: UIImageView, borderWidth: CGFloat, borderColor: UIColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0)) -> UIImageView {
        
        imageView = roundImageView(imageView)
        
        imageView.layer.borderWidth = borderWidth
        imageView.layer.borderColor = borderColor.CGColor
        
        return imageView
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

struct COLORS {
    static let red = UIColor(red: 250, green: 102, blue: 75)
    static let blue = UIColor(red: 120, green: 162, blue: 178)
    static let grey = UIColor(red: 205, green: 205, blue: 205)
    static let yellow = UIColor(red: 242, green: 203, blue: 128)
    static let black = UIColor(red: 30, green: 34, blue: 35)
}