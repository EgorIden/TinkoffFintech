//
//  ConversationsListModel.swift
//  TinkoffChat
//
//  Created by Egor on 12/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol IConversationsModel {
    func fetchChannels()
    func getContext() -> NSManagedObjectContext
    func addChannel(channel: Channel)
    func deleteChannel(identifier: String)
}
class ConversationsListModel: IConversationsModel {
    private var firebaseService: IFirebaseService
    private var coreDataService: ICoreDataService
    init(firebaseService: IFirebaseService, coreDataService: ICoreDataService) {
        self.firebaseService = firebaseService
        self.coreDataService = coreDataService
    }
    func fetchChannels() {
        firebaseService.fetchChannels {
            print("fetching channels done")
        }
    }
    func getContext() -> NSManagedObjectContext {
        return coreDataService.getContext()
    }
    func addChannel(channel: Channel) {
        firebaseService.addChannel(channel: channel)
    }
    func deleteChannel(identifier: String) {
        firebaseService.deleteChannel(channelId: identifier)
    }
}
