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
    
    static func jsonToLocation(json: JSON) -> Location {
        let id = json["_id"].string
        let title = json["title"].string
        let lat = json["geotag"]["coordinates"][1].double
        let long = json["geotag"]["coordinates"][0].double
        let description = json["description"].string
        
        var imagePathSmall = ""
        var imagePathNormal = ""
        var imagePathLarge = ""
        var imagePathXlarge = ""
        
        if (json["images"]["xlarge"].string != nil) {
            imagePathSmall = API.IMAGE_URL + json["images"]["small"].string!
            imagePathNormal = API.IMAGE_URL + json["images"]["normal"].string!
            imagePathLarge = API.IMAGE_URL + json["images"]["large"].string!
            imagePathXlarge = API.IMAGE_URL + json["images"]["xlarge"].string!
        }
        
        let userId = json["user_id"].string!
        
        let cityTitle = json["city"]["title"].string!
        let cityId = json["city"]["place_id"].string!
        let city = City(id: cityId, title: cityTitle)
        
        //if location favored by myself
        
        let location = Location(id: id!, title: title!, description: description!, long: long!, lat: lat!, city: city, imagePathSmall: imagePathSmall, imagePathNormal: imagePathNormal, imagePathLarge: imagePathLarge, imagePathXlarge: imagePathXlarge, favored: false, favorites: 0, user: User(id: userId))
        
        var favorites = [String]()
        for (_,subJson):(String, JSON) in json["favorites"] {
                favorites.append(subJson.string!)
        }
        location.userWhoFavored = favorites
        location.favorites = location.userWhoFavored.count
        
        return location
    }
    
    static func getNearby(lat: Double, long:Double, maxDistance:Float, limit:Int) -> Promise<[Location]> {
        
        return Promise { fulfill, reject in
        
        var nearbyLocations = [Location]()
        
        Alamofire.request(.GET, "https://locator-app.com/api/v2/locations/nearby", parameters: ["lat": lat, "long": long, "maxDistance":maxDistance, "limit":limit]).validate().responseJSON { response in
            switch response.result {
                case .Success:
                
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (_,subJson):(String, JSON) in json["results"] {
                            nearbyLocations.append(self.jsonToLocation(subJson["obj"]))
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
            
            Alamofire.request(.GET, API.BASE_URL + "/locations/" + id).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let location = self.jsonToLocation(json)
                        
                        UserService.getUser(location.user.id!).then {
                            result -> Void in
                            location.user = result
                            fulfill(location)
                        }
                        
                        // check if favored by myself
                        if (User.me != nil && location.userWhoFavored.contains(User.getMe().id!)) {
                            location.favored = true
                        }
                    }
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func getLocationsByUser(userId:String) -> Promise<[Location]> {
        
        return Promise { fulfill, reject in
            
            var userLocations = [Location]()
            
            Alamofire.request(.GET, API.BASE_URL + "/locations/users/" + userId).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (_,subJson):(String, JSON) in json {
                            userLocations.append(self.jsonToLocation(subJson))
                        }
                        fulfill(userLocations)
                    }
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func favLocation(id: String) -> Promise<(Int, Bool)> {
        return Promise { fulfill, reject in
            
            Alamofire.request(.POST, API.BASE_URL + "/locations/" + id + "/favor").validate().responseJSON { response in
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
            
            Alamofire.request(.GET, API.BASE_URL + "/locations/" + id + "/impressions").validate().responseJSON { response in

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
            
            Alamofire.request(.POST, API.BASE_URL + "/locations/" + id + "/impression/text", parameters: ["data": data]).validate().responseJSON { response in
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
            
            Alamofire.upload(
                .POST,
                API.BASE_URL + "/locations/" + id + "/impression/image",
                multipartFormData: { multipartFormData in
                    multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(data, 1.0)!, name: "file", fileName: "impression.jpg", mimeType: "image/jpeg")
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
                }
            )
            
        }
    }
    
}
