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
    
    static var schonHierCache = [String: SchoenHier]()
    
    static func jsonToLocation(json: JSON) -> Location {
        let id = json["_id"].string
        let title = json["title"].string
        let lat = json["geotag"]["coordinates"][1].double
        let long = json["geotag"]["coordinates"][0].double
        
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
    
        let location = Location(id: id!, title: title!, long: long!, lat: lat!, city: city, imagePathSmall: imagePathSmall, imagePathNormal: imagePathNormal, imagePathLarge: imagePathLarge, imagePathXlarge: imagePathXlarge, favored: false, favorites: 0, user: User(id: userId))
        
        //if location favored by myself
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
        
        Alamofire.request(.GET, API.BASE_URL + "/locations/nearby", parameters: ["lat": lat, "long": long, "maxDistance":maxDistance, "limit":limit]).validate().responseJSON { response in
            switch response.result {
                case .Success:
                
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (_,subJson):(String, JSON) in json {
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
        
        Alamofire.request(.GET, API.BASE_URL + "/schoenhiers/nearby", parameters: ["lat": lat, "long": long, "maxDistance":maxDistance, "limit":limit]).validate().responseJSON { response in
            switch response.result {
                case .Success:
                
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (_,subJson):(String, JSON) in json {
                            
                            let id = subJson["obj"]["_id"].string!
                            
                            if self.schonHierCache[id] != nil {
                                continue
                            }
                            
                            let lat = subJson["obj"]["geotag"]["coordinates"][1].double
                            let long = subJson["obj"]["geotag"]["coordinates"][0].double
                            let createDate = subJson["obj"]["create_date"].string
                            let schoenHier = SchoenHier(id: id, createDate: createDate!, long: long!, lat: lat!)
                            nearbySchoenHiers.append(schoenHier)
                            self.schonHierCache[id] = schoenHier
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
                        
                        location.categories.removeAll()
                        for (_,subJson):(String, JSON) in json["categories"] {
                            location.categories.append(subJson.string!)
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
    
    static func getLocationsFavoredByUser(userId:String) -> Promise<[Location]> {
        
        return Promise { fulfill, reject in
            
            var userLocations = [Location]()
            
            Alamofire.request(.GET, API.BASE_URL + "/locations/users/" + userId + "/favored").validate().responseJSON { response in
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
            
            Alamofire.request(.POST, API.BASE_URL + "/locations/" + id + "/favor/toggle").validate().responseJSON { response in
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
    
    static func createNewLocation(data:UIImage, categories:[String], locationTitle: String, lat: String, long: String) -> Promise<Location> {
        
        // init paramters Dictionary
        print("categories:", categories.description)
        print("locationTitle:", locationTitle)
        
        let parameters2 = [
            "title": locationTitle,
            "lat": lat,
            "long": long,
            "categories": categories.description
        ]
        
        // example image data
        let image = data
        let imageData = UIImageJPEGRepresentation(image, 0.5)

        let urlRequest = urlRequestWithComponents2(API.BASE_URL + "/locations", pars: parameters2, imageData: imageData!)
        return Promise { fulfill, reject in
            print("going to upload a location")
            Alamofire.upload(urlRequest.0, data: urlRequest.1).validate()
                .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                    print("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
                }
                .responseJSON {
                response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print(json)
                        fulfill(jsonToLocation(json))
                    }
                    
                case .Failure(let error):
                    print(error)
                    reject(error)
                }
            }
            
            
            
        }
    }
    
    // this function creates the required URLRequestConvertible and NSData we need to use Alamofire.upload
    static func urlRequestWithComponents2(urlString:String, pars:Dictionary<String, String>, imageData:NSData) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"file.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: image/jpeg\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(imageData)
        
        // add parameters
        for (key, value) in pars {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
    
}
