
import Foundation

class Participant {
    
    let user_id:String
    let last_read:Int
    

    
    init(user_id:String, last_read:Int) {
        self.user_id = user_id
        self.last_read = last_read
        
    }
}