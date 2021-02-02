//
//  DBMessage+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Egor on 28/10/2020.
//  Copyright © 2020 Egor. All rights reserved.
//
//

import Foundation
import CoreData


extension DBMessage {
    
    convenience init(message: Message, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.content = message.content
        self.created = message.created
        self.senderId = message.senderId
        self.senderName = message.senderName
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBMessage> {
        return NSFetchRequest<DBMessage>(entityName: "DBMessage")
    }

    @NSManaged public var content: String
    @NSManaged public var created: Date
    @NSManaged public var senderId: String
    @NSManaged public var senderName: String
    @NSManaged public var channel: DBMessage?
    
}
