//
//  Message.swift
//  locator
//
//  Created by Sergej Birklin on 25/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import Foundation

class Message {
    
    let id: String
    let conversation_id: String
    let from: String
    let message: String
    let timestamp: Int
    let modified_date: String
    let message_type: String
    
    init(id: String, conversation_id: String, from: String, message: String, timestamp: Int, modified_date: String, message_type: String) {
        self.id = id
        self.conversation_id = conversation_id
        self.from = from
        self.message = message
        self.timestamp = timestamp
        self.modified_date = modified_date
        self.message_type = message_type
    }
    
    func getMessage() -> String {
        return self.message
    }
    
}