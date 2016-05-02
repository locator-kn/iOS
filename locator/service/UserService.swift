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
        
        if (json["images"]["normal"].string != nil && json["images"]["small"].string != nil) {
            imagePathNormal = API.IMAGE_URL + json["images"]["normal"].string!
            imagePathThumb = API.IMAGE_URL + json["images"]["small"].string!
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
                        let user = self.jsonToUser(json)
                        TrackingService.sharedInstance.trackEvent("App | Login")
                        TrackingService.sharedInstance.setIdentity(user.id!, name: user.name!, mail: user.email!)
                        registerPush()
                        fulfill(user)
                    }
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func logout() -> Promise<AnyObject> {
        
        return Promise { fulfill, reject in
            
            Alamofire.request(.GET, API.USER_LOGOUT).validate().responseJSON {
                response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        print("youre logout")
                        TrackingService.sharedInstance.trackEvent("App | Logout")
                        NSUserDefaults.standardUserDefaults().removeObjectForKey("userimg")
                        fulfill(value)
                    }
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func register(mail:String, password:String, name: String, residence: String) -> Promise<User> {
        
        return Promise { fulfill, reject in
            
            Alamofire.request(.POST, API.USER_REGISTER, parameters: ["mail": mail, "password": password, "name": name, "residence": residence])
                .validate()
                .responseJSON {
                response in
                
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        let user = jsonToUser(json)
                        TrackingService.sharedInstance.setIdentity(user.id!, name: user.name!, mail: user.email!)
                        TrackingService.sharedInstance.trackEvent("App | Register")
                        registerPush()
                        fulfill(user)
                    }
                    
                case .Failure(let error):
                    print(error)
                    reject((NSError(domain: "register error", code: response.response!.statusCode, userInfo: nil)))
                }
            }
        }
    }
    
    static func facebookLogin(token: NSString) -> Promise<User> {
        
        return Promise { fulfill, reject in
            
            Alamofire.request(.POST, API.FACEBOOK_LOGIN, parameters: ["token": token]).validate().responseJSON {
                response in
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let user = self.jsonToUser(json)
                        TrackingService.sharedInstance.setIdentity(user.id!, name: user.name!, mail: user.email!)
                        TrackingService.sharedInstance.trackEvent("App | FB Login")
                        registerPush()
                        fulfill(user)
                    }
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
                    fulfill(503)
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
    
    static func unfollow(userId:String) -> Promise<Bool> {
        
        return Promise { fulfill, reject in
            
            Alamofire.request(.POST, API.BASE_URL + "/users/" + userId + "/unfollow").validate().responseJSON {
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
    
    static func resetPassword(mail:String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            Alamofire.request(.POST, API.RESET_PASSWORD, parameters: ["mail": mail])
                .validate()
                .responseJSON {
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
    
    static func changePassword(oldPassword: String, newPassword: String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            Alamofire.request(.PUT, API.CHANGE_PASSWORD, parameters: ["old_password": oldPassword, "new_password": newPassword])
                .validate()
                .responseJSON {
                    response in
                    print(response)
                    switch response.result {
                    case .Success:
                            fulfill(true)
                    case .Failure(let error):
                        reject(error)
                    }
            }
        }
    }
    
    static func uploadProfileImg(image: UIImage) -> Promise<Bool> {
        return Promise { fulfill, reject in
            Alamofire.upload(
                .POST,
                API.PROFIL_IMAGE_UPLOAD,
                multipartFormData: { multipartFormData in
                    multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(image, 0.6)!, name: "file", fileName: "userProfilImage.jpg", mimeType: "image/jpeg")
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success( _, _, _):
                        fulfill(true)
                    case .Failure(let error):
                        print(error)
                        reject(error)
                    }
                }
            )
        }
    }
    
    static func registerPush() {
      /*  let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge , .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications() */
    }

}
