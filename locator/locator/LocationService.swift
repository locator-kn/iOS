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
    
    static func getNearby(lat: Double, long:Double, maxDistance:Int, limit:Int) -> [Location] {
        
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
                        nearbyLocations.append(Location(title: title!, long: long!, lat: lat!))
                        
                    }
                    
                }
                
            case .Failure(let error):
                print(error)
            }
           
        }
         return nearbyLocations

    }

    
    
}