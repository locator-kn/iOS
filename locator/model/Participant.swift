
import Foundation

class Participant {
    
    let user_id:String
    let last_read:Int
    let user:User
    

    
    init(user_id:String, last_read:Int, user:User) {
        self.user_id = user_id
        self.last_read = last_read
        self.user = user
    }
}