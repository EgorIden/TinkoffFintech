//
//  Models.swift
//  TinkoffChat
//
//  Created by Egor on 29/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Firebase
import UIKit

struct ConversationCellModel {
    let name: String
    let message: String?
    let date: Date
    let isOnline: Bool
    let hasUnreadedMessages: Bool
    
    init(channel: DBChannel) {
        self.name = channel.name
        self.message = channel.lastMessage ?? "No message"
        if let lastActivity = channel.lastActivity{
            self.date = lastActivity
        }else{
            self.date = Timestamp.init(date: Date.init()).dateValue()
        }
        if date.timeIntervalSinceNow  < TimeInterval(-300){
            self.isOnline = true
        }else{
            self.isOnline = false
        }
        self.hasUnreadedMessages = isOnline
    }
}
