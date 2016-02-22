//
//  ConversationService.swift
//  locator
//
//  Created by Timo Weiß on 22.02.16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

class ConversationService {
    static func getShit() -> Promise<[Conversation]> {
        
        var conversations=[Conversation]()
        
        return Promise { fullfill, reject in
            Alamofire.request(.GET, API.BASE_URL + "/my/conversations").validate().responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (_, subJson):(String, JSON) in json {
                            conversations.append(jsonToConversation(subJson))
                        }
                        fullfill(conversations)
                    }
                    
                case .Failure(let error):
                    reject(error)
                }
                
                
            }
            
        }
        
    }
    
    static func jsonToConversation(json:JSON) -> Conversation {
        var participants = [Participant]()
        
        let _id = json["_id"].string
        for (_, sub):(String, JSON) in json["participants"] {
            participants.append(jsonToParticipant(sub))
        }
        return Conversation(_id: _id!, participants: participants)

        
    }
    static func jsonToParticipant(json:JSON) -> Participant {
        
        let user_id = json["user_id"].string
        let last_read = json["last_read"].int
        
        return Participant(user_id: user_id!, last_read: last_read!)
        
    }
}
