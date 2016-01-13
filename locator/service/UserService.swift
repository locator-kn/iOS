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
    
    static func login(mail:String, password:String) -> Promise<User> {
        
        return Promise { fulfill, reject in
        
            Alamofire.request(.POST, "https://locator-app.com/api/v2/users/login", parameters: ["mail": mail, "password": password]).validate().responseJSON {
                response in
                
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                            
                        let id = json["_id"].string
                        let name = json["name"].string
                        let email = json["mail"].string
                       
                        fulfill(User(id: id!, name: name!, email: email!))
                    }
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    

    static func protected() -> Promise<Int> {
        
        return Promise { fulfill, reject in
            
            Alamofire.request(.GET, "https://locator-app.com/api/v2/users/protected").validate().responseJSON {
                response in
                fulfill((response.response?.statusCode)!)
            }
        }
    }
}