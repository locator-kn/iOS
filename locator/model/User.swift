//
//  User.swift
//  locator
//
//  Created by Michael Knoch on 22/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation

class User {
    let id:String
    let name:String
    let email:String
    
    static var me:User!
    
    init(id:String, name:String, email:String) {
        self.id = id
        self.name = name
        self.email = email
    }
    
    static func setMe(me:User) {
        self.me = me
    }
    
    static func getMe() -> User {
        return self.me
    }
}