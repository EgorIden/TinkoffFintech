//
//  DBChannel+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Egor on 28/10/2020.
//  Copyright © 2020 Egor. All rights reserved.
//
//

import Foundation
import CoreData

extension DBChannel {

    convenience init(channel: Channel, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = channel.identifier
        self.name = channel.name
        self.lastMessage = channel.lastMessage
        self.lastActivity = channel.lastActivity
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBChannel> {
        return NSFetchRequest<DBChannel>(entityName: "DBChannel")
    }

    @NSManaged public var identifier: String
    @NSManaged public var lastActivity: Date?
    @NSManaged public var lastMessage: String?
    @NSManaged public var name: String
    @NSManaged public var message: NSSet
    
}

// MARK: Generated accessors for message
extension DBChannel {

    @objc(addMessageObject:)
    @NSManaged public func addToMessage(_ value: DBMessage)

    @objc(removeMessageObject:)
    @NSManaged public func removeFromMessage(_ value: DBMessage)

    @objc(addMessage:)
    @NSManaged public func addToMessage(_ values: NSSet)

    @objc(removeMessage:)
    @NSManaged public func removeFromMessage(_ values: NSSet)

}
