

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
                        for item in conversations {
                            print("lalala conversations for")
                            print("Item id", item._id)
                            for user in item.participants {
                                print("my userid:", User.me?.id)
                                if user.user_id == User.me?.id {
                                    print("its me")
                                }
                            }
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
        var message: Optional<Message>
        
        let _id = json["_id"].string
        for (_, sub):(String, JSON) in json["participants"] {
            participants.append(jsonToParticipant(sub))
        }
        
        if json["last_message"] != "" && json["last_message"] != nil {
            message = jsonToMessage(json["last_message"])
        }
        
        // TODO: message might be nil
        return Conversation(_id: _id!, participants: participants, last_message: message!)

        
    }
    
    static func jsonToMessage(json:JSON) -> Message {
        return Message(
            id: json["_id"].string!,
            conversation_id: json["conversation_id"].string!,
            from: json["from"].string!,
            message: json["message"].string!,
            timestamp: json["timestamp"].int!,
            message_type: json["message_type"].string!
        )
    }
    
    static func jsonToParticipant(json:JSON) -> Participant {
        
        let user_id = json["user_id"].string
        let last_read = json["last_read"].int
        
        return Participant(user_id: user_id!, last_read: last_read!)
        
    }
}
