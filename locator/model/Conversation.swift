
import Foundation

class Conversation {
    
    let _id:String
    let participants:[Participant]
    
    init(_id: String, participants:[Participant]) {
        self._id = _id
        self.participants = participants
    }
}