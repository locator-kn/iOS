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