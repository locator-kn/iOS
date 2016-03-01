//
//  UserService.swift
//  locator
//
//  Created by Michael Knoch on 22/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

class UserService {
    
    static func jsonToUser(json: JSON) -> User {
        let id = json["_id"].string!
        let email = json["mail"].string!
        let name = json["name"].string!
        let residence = json["residence"].string!
        
        var imagePathNormal = ""
        var imagePathThumb = ""
        
        if (json["picture"].string != nil && json["thumb"].string != nil) {
            imagePathNormal = API.IMAGE_URL + json["picture"].string!
            imagePathThumb = API.IMAGE_URL + json["thumb"].string!
        }
        
        var following = [String]()
        for (_,subJson):(String, JSON) in json["following"] {
            following.append(subJson.string!)
        }
        let user = User(id: id, email: email, name: name, imagePathNormal: imagePathNormal, imagePathThumb: imagePathThumb, residence: residence)
        user.following = following
        
        return user
    }
    
    static func login(mail:String, password:String) -> Promise<User> {
        
        return Promise { fulfill, reject in
        
            Alamofire.request(.POST, API.USER_LOGIN, parameters: ["mail": mail, "password": password]).validate().responseJSON {
                response in
                
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        fulfill(self.jsonToUser(json))
                    }
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func register(mail:String, password:String, name: String, residence: String) -> Promise<AnyObject> {
        
        return Promise { fulfill, reject in
            
            Alamofire.request(.POST, API.USER_REGISTER, parameters: ["mail": mail, "password": password, "name": name, "residence": residence])
                .validate()
                .responseJSON {
                response in
                
                switch response.result {
                case .Success:
                    
//                    if let value = response.result.value {
//                        let json = JSON(value)
//                        
//                        let id = json["_id"].string
//                        let name = json["name"].string
//                        let email = json["mail"].string
//                        
                        fulfill("Success")
//                    }
                    
                case .Failure(let error):
                    
                    reject(error)
                }
            }
        }
    }

    static func protected() -> Promise<Int> {
        
        return Promise { fulfill, reject in
            
            Alamofire.request(.GET, API.USER_PROTECTED).validate().responseJSON {
                response in
                
                if response.response != nil {
                    fulfill((response.response!.statusCode))
                } else {
                    fulfill(401)
                }
            }
        }
    }
    
    static func getUser(id:String) -> Promise<User> {
        
        return Promise { fulfill, reject in
            
            Alamofire.request(.GET, API.BASE_URL + "/users/" + id + "?count=followers,locations").validate().responseJSON {
                response in
                
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let user = jsonToUser(json)
                        let locationCount = json["location_count"].int!
                        let followerCount = json["follower_count"].int!
                        
                        user.locationCount = locationCount
                        user.followerCount = followerCount
                        
                        fulfill(user)
                    }
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func getFollower(userId:String, following:Bool) -> Promise<[User]> {
        
        return Promise { fulfill, reject in
            
            var follower = [User]()
            
            var routePath = "follower"
            if following {
                routePath = "following"
            }
            
            Alamofire.request(.GET, API.BASE_URL + "/users/" + userId + "/" + routePath).validate().responseJSON {
                response in
                
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (_,subJson):(String, JSON) in json {
                            follower.append(self.jsonToUser(subJson))
                        }
                        fulfill(follower)
                    }
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
        
    }
    
    static func follow(userId:String) -> Promise<Bool> {
        
        return Promise { fulfill, reject in
            
            Alamofire.request(.POST, API.BASE_URL + "/users/" + userId + "/follow").validate().responseJSON {
                response in
                
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
