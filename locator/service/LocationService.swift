//
//  LocationService.swift
//  locator
//
//  Created by Michael Knoch on 16/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LocationService {
    
    static func getNearby(lat: Double, long:Double, maxDistance:Double, limit:Int, callback: (([Location]) -> Void)) {
        
        var nearbyLocations = [Location]()
        
        Alamofire.request(.GET, "https://locator-app.com/api/v2/locations/nearby", parameters: ["lat": lat, "long": long, "maxDistance":maxDistance, "limit":limit]).validate().responseJSON { response in
            switch response.result {
            case .Success:
                
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    for (_,subJson):(String, JSON) in json["results"] {
                        
                        let lat = subJson["obj"]["geotag"]["coordinates"][1].double
                        let long = subJson["obj"]["geotag"]["coordinates"][0].double
                        let title = subJson["obj"]["title"].string
                        let id = subJson["obj"]["_id"].string
                        
                        nearbyLocations.append(Location(id: id!, title: title!, long: long!, lat: lat!))
                        
                    }
                    callback(nearbyLocations)
                    
                }
                
            case .Failure(let error):
                print(error)
            }
           
        }
    }
    
    
    static func getSchoenHiers(lat: Double, long:Double, maxDistance:Double, limit:Int, callback: (([SchoenHier]) -> Void)) {
        
        var nearbySchoenHiers = [SchoenHier]()
        
        Alamofire.request(.GET, "https://locator-app.com/api/v2/schoenhiers/nearby", parameters: ["lat": lat, "long": long, "maxDistance":maxDistance, "limit":limit]).validate().responseJSON { response in
            switch response.result {
            case .Success:
                
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    for (_,subJson):(String, JSON) in json["results"] {
                        
                        print(subJson)
                        
                        let lat = subJson["obj"]["geotag"]["coordinates"][1].double
                        let long = subJson["obj"]["geotag"]["coordinates"][0].double
                        let createDate = "todo"
                        let id = subJson["obj"]["_id"].string
                        
                        nearbySchoenHiers.append(SchoenHier(id: id!, createDate: createDate, long: long!, lat: lat!))
                        
                    }
                    callback(nearbySchoenHiers)
                }
                
            case .Failure(let error):
                print(error)
            }
            
        }
    }

}