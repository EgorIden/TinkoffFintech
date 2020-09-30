//
//  Models.swift
//  TinkoffChat
//
//  Created by Egor on 29/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

struct ConversationCellModel {
    let name: String
    let message: String
    let date: Date
    let isOnline: Bool
    let hasUnreadedMessages: Bool
}
