//
//  FirebaseModels.swift
//  TinkoffChat
//
//  Created by Egor on 21/10/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import Firebase

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}
