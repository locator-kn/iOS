
import Foundation

class Conversation {
    
    let _id:String
    let participants:[Participant]
    var last_message:Message
    
    init(_id: String, participants:[Participant], last_message:Message) {
        self._id = _id
        self.participants = participants
        self.last_message = last_message
    }
}