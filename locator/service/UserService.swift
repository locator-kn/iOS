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
        
            Alamofire.request(.POST, API.USER_LOGIN, parameters: ["mail": mail, "password": password]).validate().responseJSON {
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
                fulfill((response.response?.statusCode)!)
            }
        }
    }
}


extension NSError {
    
}