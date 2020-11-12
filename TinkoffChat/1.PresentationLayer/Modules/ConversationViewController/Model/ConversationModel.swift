//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Egor on 13/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol IConversationModel {
    func fetchMessages(channelId: String)
    func getContext() -> NSManagedObjectContext
    func sendMessage(senderId: String, channelId: String, message: String)
}
class ConversationListModel: IConversationModel {
    private var firebaseService: IFirebaseService
    private var coreDataService: ICoreDataService
    init(firebaseService: IFirebaseService, coreDataService: ICoreDataService) {
        self.firebaseService = firebaseService
        self.coreDataService = coreDataService
    }
    func fetchMessages(channelId: String) {
        firebaseService.fetchMessages(identifier: channelId) {
            print("fetching messages done")
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        coreDataService.getContext()
    }
    
    func sendMessage(senderId: String, channelId: String, message: String) {
        firebaseService.sendMessage(senderId: senderId, channelId: channelId, message: message)
    }
}
