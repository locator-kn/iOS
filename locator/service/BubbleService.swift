//
//  BubbleService.swift
//  locator
//
//  Created by Sergej Birklin on 25/01/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

class BubbleService {
    
    static func getBubbles(lat: Double, long:Double, maxDistance:Float, limit:Int) -> Promise<[Location]> {
        
        return Promise { fulfill, reject in

            var locations = [Location]()
            
            Alamofire.request(.GET, API.BUBBLE_INPUT, parameters: ["lat": lat, "long": long, "maxDistance":maxDistance, "limit":limit]).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        for (_,subJson):(String, JSON) in json["locations"] {
                            locations.append(LocationService.jsonToLocation(subJson["obj"]))
                        }
                        
                        fulfill(locations)
                    }
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
}