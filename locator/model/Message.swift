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
    let message_type: String
    
    init(id: String, conversation_id: String, from: String, message: String, timestamp: Int, message_type: String) {
        self.id = id
        self.conversation_id = conversation_id
        self.from = from
        self.message = message
        self.timestamp = timestamp
        self.message_type = message_type
    }
    
    func getMessage() -> String {
        return self.message
    }
    
}