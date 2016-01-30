//
//  DeviceService.swift
//  locator
//
//  Created by Michael Knoch on 30/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

class DeviceService {
    
    static func getDeviceData() -> [String: String] {
        var deviceData = [String: String]()
        deviceData["deviceId"] = UIDevice.currentDevice().identifierForVendor!.UUIDString
        deviceData["manufacturer"] = "apple"
        deviceData["deviceModel"] = UIDevice.currentDevice().model
        deviceData["version"] = UIDevice.currentDevice().systemVersion
        deviceData["type"] = "ios"
        return deviceData
    }

    static func registerDevice(deviceData: [String:String]) -> Promise<Bool> {
        
        return Promise { fulfill, reject in
            
            Alamofire.request(.POST, API.BASE_URL + "/device/register", parameters: deviceData).validate().responseJSON {
                response in
                
                switch response.result {
                case .Success:
                    fulfill(true)
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }

}

