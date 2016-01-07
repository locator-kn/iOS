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
    var name:String!
    var email:String!
    
    static var me:User!
    
    init(id:String) {
        self.id = id
    }
    
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