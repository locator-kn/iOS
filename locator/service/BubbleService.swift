//
//  BubbleService.swift
//  locator
//
//  Created by Sergej Birklin on 25/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

class BubbleService {
    
    static func getBubbles(lat: Double, long:Double, maxDistance:Float, limit:Int) -> Promise<[AnyObject]> {
        
        return Promise { fulfill, reject in
            
            var messages = [Message]()
            var locations = [Location]()
            var bubbles = [AnyObject]()
            
            Alamofire.request(.GET, API.BUBBLE_INPUT, parameters: ["lat": lat, "long": long, "maxDistance":maxDistance, "limit":limit]).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        for (_,subJson):(String, JSON) in json["messages"] {
                            let id = subJson["_id"].string
                            let conversation_id = subJson["conversation_id"].string
                            let from = subJson["from"].string
                            let message = subJson["message"].string
                            let timestamp = subJson["timestamp"].int
                            let modified_date = subJson["modified_date"].string
                            let message_type = subJson["message_type"].string
                            messages.append(Message(id: id!, conversation_id: conversation_id!, from: from!, message: message!, timestamp: timestamp!, modified_date: modified_date!, message_type: message_type!))
                        }
                        
                        for (_,subJson):(String, JSON) in json["locations"] {
                            let id = subJson["obj"]["_id"].string
                            let title = subJson["obj"]["title"].string
                            let lat = subJson["obj"]["geotag"]["coordinates"][1].double
                            let long = subJson["obj"]["geotag"]["coordinates"][0].double
                            var imagePath = ""
                            if (subJson["obj"]["images"]["normal"].string != nil) {
                                imagePath = "https://locator-app.com/" + subJson["obj"]["images"]["normal"].string!
                            }
                            let location = Location(id: id!, title: title!, long: long!, lat: lat!, imagePath: imagePath)
                            locations.append(location)
                        }
                        
                        bubbles.append(messages)
                        bubbles.append(locations)
                        fulfill(bubbles)
                    }
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
}