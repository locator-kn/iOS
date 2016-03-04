//
//  HttpService.swift
//  locator
//
//  Created by Sergej Birklin on 16/12/15.
//  Copyright © 2015 Sergej Birklin. All rights reserved.
//

import Foundation
import Alamofire

class HttpService {
    
    static func get(withURL: String,
        jsonString: Dictionary<String, AnyObject>?,
        success: ((AnyObject) -> Void)!,
        failure: ((NSError, AnyObject?) -> Void)!) {
        
        Alamofire.request(.GET, withURL, parameters: jsonString)
            .responseJSON { response in
                //print(response.description)
                switch response.result {
                case .Success:
                    success(response.result.value!)
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    static func post(withURL: String,
        jsonString: Dictionary<String, AnyObject>?,
        success: ((AnyObject) -> Void)!,
        failure: ((NSError, AnyObject?) -> Void)!) {
            
            
            Alamofire.request(.POST, withURL, parameters: jsonString)
                .responseJSON { response in
                    //print(response.description)
                    switch response.result {
                    case .Success:
                        success(response.result.value!)
                    case .Failure(let error):
                        print(error)
                    }
            }
    }
}

struct API {
    static let BASE_URL = "https://locator-app.com/api/v2"
    static let IMAGE_URL = "https://locator-app.com"
    static let USER_LOGIN = "\(BASE_URL)/users/login"
    static let USER_REGISTER = "\(BASE_URL)/users/register"
    static let USER_LOGOUT = "\(BASE_URL)/users/logout"
    static let USER_PROTECTED = "\(BASE_URL)/users/protected"
    static let BUBBLE_INPUT = "\(BASE_URL)/my/bubblescreen"
    static let PROFIL_IMAGE_UPLOAD = "\(BASE_URL)/users/image"
    static let FACEBOOK_LOGIN = "\(BASE_URL)/users/facebooklogin"
    static let RESET_PASSWORD = "\(BASE_URL)/my/users/forgetPassword"
    static let CHANGE_PASSWORD = "\(BASE_URL)/my/users/changePwd"
}



