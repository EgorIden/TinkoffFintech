//
//  MessageCellModel.swift
//  TinkoffChat
//
//  Created by Egor on 30/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

struct MessageCellModel {
    let senderName: String
    let text: String
    let isOutput: Bool
    init(message: DBMessage, myID: String) {
        self.senderName = message.senderName
        self.text = message.content
        if message.senderId != myID {
            self.isOutput = false
        } else {
            self.isOutput = true
        }
    }
}
