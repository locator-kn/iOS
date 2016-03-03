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
    
    static var me:User?
    
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
    var favoredLocations:[Location]?
    var follower:[User]?
    var followedBy:[User]?
    var following: [String]?
    var mefollowing: Bool = false
    
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
    
    func getFavoredLocations() -> Promise<[Location]> {
        return Promise { fulfill, reject in
            LocationService.getLocationsFavoredByUser(self.id!).then {
                result -> Void in
                self.favoredLocations = result
                fulfill(self.favoredLocations!)
            }
        }
    }
    
    func follow() -> Promise<Bool> {
        self.mefollowing = true
        User.me?.following?.append(self.id!)
        return UserService.follow(self.id!)
    }
    
    func unfollow() -> Promise<Bool> {
        self.mefollowing = false
        let index = User.me!.following?.indexOf(self.id!)
        User.me!.following?.removeAtIndex(index!)
        return UserService.unfollow(self.id!)
    }
    
    static func setMe(me:User) {
        self.me = me
    }
    
    static func getMe() -> User {
        return self.me!
    }
}