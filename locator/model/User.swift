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
    var profilImage: UIImage?
    var locationCount:Int?
    var followerCount:Int?
    
    var locations:[Location]?
    var follower:[User]?
    var followedBy:[User]?
    
    init(id:String) {
        self.id = id
    }
    
    init(id:String, name:String, email:String) {
        self.id = id
        self.name = name
        self.email = email
    }
    
    init(id:String, name:String, profileImage:UIImage) {
        self.id = id
        self.name = name
        self.profilImage = profileImage
    }
    
    init(id:String, name:String, profileImage:UIImage, locationCount:Int, followerCount:Int) {
        self.id = id
        self.name = name
        self.profilImage = profileImage
        self.locationCount = locationCount
        self.followerCount = followerCount
    }
    
    init(name: String, email: String, residence: String, password: String, profilImage: UIImage) {
        self.id = nil
        self.name = name
        self.email = email
        self.residence = residence
        self.password = password
        self.profilImage = profilImage
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