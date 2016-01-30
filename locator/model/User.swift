//
//  User.swift
//  locator
//
//  Created by Michael Knoch on 22/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class User {
    
    static var me:User!
    
    let id:String?
    var name:String?
    var email:String?
    var residence: String?
    var password: String?
    
    var locationCount:Int?
    var followerCount:Int?
    
    var imagePathNormal: String?
    var imagePathThumb:String?
    
    var locations:[Location]?
    var follower:[User]?
    var followedBy:[User]?
    
    init(id:String) {
        self.id = id
    }
        
    init(id: String, email:String, name: String, imagePathNormal: String, imagePathThumb: String, residence: String) {
        self.id = id
        self.email = email
        self.name = name
        self.imagePathNormal = imagePathNormal
        self.imagePathThumb = imagePathThumb
        self.residence = residence
    }
    
    func getFollower() -> Promise<[User]> {
        return Promise { fulfill, reject in
            UserService.getFollower(self.id!, following: true).then {
                result -> Void in
                self.follower = result
                fulfill(self.follower!)
            }
        }
    }
    
    func getFollowedBy() -> Promise<[User]> {
        return Promise { fulfill, reject in
        
        UserService.getFollower(self.id!, following: false).then {
            result -> Void in
                self.followedBy = result
                fulfill(self.followedBy!)
            }
        }
    }
    
    func getLocations() -> Promise<[Location]> {
        return Promise { fulfill, reject in
        LocationService.getLocationsByUser(self.id!).then {
            result -> Void in
                self.locations = result
                fulfill(self.locations!)
            }
        }
    }
    
    func follow() -> Promise<Bool> {
        return UserService.follow(self.id!)
    }
    
    static func setMe(me:User) {
        self.me = me
    }
    
    static func getMe() -> User {
        return self.me
    }
}