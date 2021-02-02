//
//  CoreDataManager.swift
//  TinkoffChat
//
//  Created by Egor on 11/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//
import CoreData
protocol ICoreDataService {
    func saveChannels(channels: [Channel])
    func saveMessages(identifier: String, messages: [Message])
    func deleteChannel(channelId: String)
    func getContext() -> NSManagedObjectContext
}

import Foundation
class CoreDataManager: ICoreDataService {
    let coreData: CoreDataStack
    
    init(coreData: CoreDataStack) {
        self.coreData = coreData
    }
    func getContext() -> NSManagedObjectContext {
        return coreData.mainContext
    }
    func saveChannels(channels: [Channel]) {
        DispatchQueue.global().async { [weak self] in
            self?.coreData.performSave { context in
                channels.forEach { channel in
                    _ = DBChannel(channel: channel, in: context)
                }
            }
        }
    }

    func saveMessages(identifier: String, messages: [Message]) {
        DispatchQueue.global().async { [weak self] in
            self?.coreData.performSave { context in
                let request: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
                request.predicate = NSPredicate(format: "identifier = %@", identifier)
                request.returnsObjectsAsFaults = false
                let result = try? context.fetch(request)
                if let channel = result?.first {
                    print("Messages in save-> \(messages.count)")
                    let messages = messages.map { message -> DBMessage in
                        let someMessage = DBMessage(message: message, in: context)
                        return someMessage
                    }
                    messages.forEach({channel.addToMessage($0)})
                }
            }
        }
    }

    func deleteChannel(channelId: String) {
        let context = self.coreData.mainContext
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", channelId)
        let result = try? context.fetch(fetchRequest)
        if let channel = result?.first {
            context.delete(channel)
            do {
                try self.coreData.mainContext.save()
            } catch {
                print("deleting error -> \(error.localizedDescription)")
            }
        }
    }
    }
