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
import SystemConfiguration

class DeviceService {
    
    static func getDeviceData() -> [String: String] {
        var deviceData = [String: String]()
        deviceData["deviceId"] = UIDevice.currentDevice().identifierForVendor!.UUIDString
        deviceData["deviceModel"] = UIDevice.currentDevice().model
        deviceData["version"] = UIDevice.currentDevice().systemVersion
        deviceData["type"] = "ios"
        deviceData["manufacturer"] = "apple"
        return deviceData
    }

    static func registerDevice(deviceData: [String:String]) -> Promise<Bool> {
        print("Token: ", deviceData["pushToken"])
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
    
    static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

}

