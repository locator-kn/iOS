//
//  User.swift
//  locator
//
//  Created by Michael Knoch on 22/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    let id:String?
    var name:String?
    var email:String?
    var residence: String?
    var password: String?
    var profilImage: UIImage?
    
    static var me:User!
    
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
    
    init(name: String, email: String, residence: String, password: String, profilImage: UIImage) {
        self.id = nil
        self.name = name
        self.email = email
        self.residence = residence
        self.password = password
        self.profilImage = profilImage
    }
    
    static func setMe(me:User) {
        self.me = me
    }
    
    static func getMe() -> User {
        return self.me
    }
}