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
import PromiseKit

class LocationService {
    
    static func getNearby(lat: Double, long:Double, maxDistance:Float, limit:Int) -> Promise<[Location]> {
        
        return Promise { fulfill, reject in
        
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
                        fulfill(nearbyLocations)
                    
                    }
                case .Failure(let error):
                    reject(error)
                }
           
            }
        }
    }
    
    
    static func getSchoenHiers(lat: Double, long:Double, maxDistance:Float, limit:Int) -> Promise<[SchoenHier]> {
    
        return Promise { fulfill, reject in
    
        var nearbySchoenHiers = [SchoenHier]()
        
        Alamofire.request(.GET, "https://locator-app.com/api/v2/schoenhiers/nearby", parameters: ["lat": lat, "long": long, "maxDistance":maxDistance, "limit":limit]).validate().responseJSON { response in
            switch response.result {
                case .Success:
                
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (_,subJson):(String, JSON) in json["results"] {
                                let lat = subJson["obj"]["geotag"]["coordinates"][1].double
                            let long = subJson["obj"]["geotag"]["coordinates"][0].double
                            let createDate = subJson["obj"]["create_date"].string
                            let id = subJson["obj"]["_id"].string
                            nearbySchoenHiers.append(SchoenHier(id: id!, createDate: createDate!, long: long!, lat: lat!))
                        }
                        
                    fulfill(nearbySchoenHiers)
                }
                
                case .Failure(let error):
                    reject(error)
                }
            
            }
        }
    }
    
    
    static func schonHier(lat: Double, long:Double) -> Promise<SchoenHier> {
        return Promise { fulfill, reject in
            
        Alamofire.request(.POST, "https://locator-app.com/api/v2/schoenhiers", parameters: ["lat": lat, "long": long]).validate().responseJSON { response in
            switch response.result {
                case .Success:
                
                    if let value = response.result.value {
                        let json = JSON(value)
                
                        let id = json["_id"].string
                        let lat = json["geotag"]["coordinates"][1].double
                        let long = json["geotag"]["coordinates"][0].double
                        let createDate = json["create_date"].string

                        fulfill(SchoenHier(id: id!, createDate: createDate!, long: long!, lat: lat!))
                    }
                
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    

    static func locationById(id: String) -> Promise<Location> {
        return Promise { fulfill, reject in
            
            Alamofire.request(.GET, "https://locator-app.com/api/v2/locations/" + id).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        let id = json["_id"].string
                        let title = json["title"].string
                        let lat = json["geotag"]["coordinates"][1].double
                        let long = json["geotag"]["coordinates"][0].double
                        let city = json["city"]["title"].string
                        let description = json["description"].string
                        
                        var imagePath = ""
                        
                        if (json["images"]["normal"].string != nil) {
                            imagePath = json["images"]["normal"].string!
                        }
                        
                        fulfill((Location(id: id!, title: title!, description: description!, long: long!, lat: lat!, city: city!, imagePath: imagePath)))
                    }
                    
                case .Failure(let error):
                    reject(error)
                }
            }

            
        }
    }

}