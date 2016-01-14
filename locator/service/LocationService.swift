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
                        
                        if (json["images"]["xlarge"].string != nil) {
                            imagePath = "https://locator-app.com/" + json["images"]["xlarge"].string!
                        }
                        
                        //if location favored by myself
                        var favored = false
                        for (_,subJson):(String, JSON) in json["favorites"] {
                            
                            if (subJson.string == UtilService.getMyId()) {
                                favored = true
                                break
                            }
                        }
                        
                        fulfill((Location(id: id!, title: title!, description: description!, long: long!, lat: lat!, city: city!, imagePath: imagePath, favored: favored, favorites: 0)))
                    }
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func favLocation(id: String) -> Promise<(Int, Bool)> {
        return Promise { fulfill, reject in
            
            Alamofire.request(.POST, "https://locator-app.com/api/v2/locations/" + id + "/favor").validate().responseJSON { response in
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        print(json)
                        fulfill((json["favorites"].int!, json["added"].bool!))
                    }
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func getStream(id: String) -> Promise<[AbstractImpression]> {
        return Promise { fulfill, reject in
            
            Alamofire.request(.GET, "https://locator-app.com/api/v2/locations/" + id + "/stream").validate().responseJSON { response in
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        print(json)
                        
                        var impressions = [AbstractImpression]()
                        
                        for (_,subJson):(String, JSON) in json {
                            
                            let user = subJson["user_id"].string
                            let date = subJson["create_date"].string
                            let type = subJson["type"].string
                            let dataPath = subJson["data"].string
                            
                            if type == "text" {
                                let data = dataPath!.dataUsingEncoding(NSUTF8StringEncoding)
                                impressions.append(TextImpression(date:date!, userId: user!, data: data!))
                                break
                                
                            } else if type == "image" {
                                let data = UtilService.dataFromPath(dataPath!)
                                impressions.append(ImageImpression(date:date!, userId: user!, data: data))
                                break
                            
                            } else if type == "audio" {
                                // TODO
                                
                            } else if type == "video" {
                                //TODO
                                
                            }
                        }
                        fulfill(impressions)
                        
                    }
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func addTextImpression(id: String, data:String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            
            Alamofire.request(.POST, "https://locator-app.com/api/v2/locations/" + id + "/stream/text", parameters: ["data": data]).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    
                    fulfill(true)
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func addImageImpression(id: String, data:UIImage) -> Promise<Bool> {
        return Promise { fulfill, reject in
            
            Alamofire.upload(.POST, "https://locator-app.com/api/v2/locations/" + id + "/stream/image", data: UIImageJPEGRepresentation(data, 1.0)!).validate().responseJSON {
                response in
                
                print(data)
                
                switch response.result {
                case .Success:
                    
                    fulfill(true)
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
}
