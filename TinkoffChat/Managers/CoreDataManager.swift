//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Egor on 25/10/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import CoreData

//CoreDataStack
class CoreDataManager {
    
    static var shared = CoreDataManager()
    private init() {}
    
    var didUpdateDatabase: ((CoreDataManager) -> Void)?
    var storeURL: URL = {
        guard let docURL = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).last else{
            fatalError("document path not found")
        }
        return docURL.appendingPathComponent("Chat.sqlite")
    }()
    
    private let dataModelName = "Chat"
    private let dataModelExtension = "momd"
    
    //init stack
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension) else {
            fatalError("model not found")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else{
            fatalError("managedObjectModel could not be created")
        }
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator (managedObjectModel: self.managedObjectModel)
        do{
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: nil)
        }catch{
            fatalError(error.localizedDescription)
        }
        return coordinator
    }()
    
    private lazy var writtenContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writtenContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }
    
    func performSave(_ block: (NSManagedObjectContext) -> Void){
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges{
                do {try performSave(in: context)}
                catch {assertionFailure(error.localizedDescription)}
            }
        }
    }
    private func performSave(in context: NSManagedObjectContext) throws{
        print("mainthread-> \(Thread.isMainThread)")
        try context.save()
        if let parent = context.parent{try performSave(in: parent)}
    }
    //Save channels
    func saveChannelToDB(channels: [Channel]) {
        DispatchQueue.global().async { [weak self] in
            self?.performSave { context in
                channels.forEach { channel in
                    _ = DBChannel(channel: channel, in: context)
                }
            }
        }
    }
    //Save messages
    func saveMessageToDB(id: String, messages: [Message]) {
        DispatchQueue.global().async { [weak self] in
            self?.performSave { context in
                let request: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
                request.predicate = NSPredicate(format: "identifier = %@", id)
                request.returnsObjectsAsFaults = false
                
                let result = try? context.fetch(request)
                if let channel = result?[0]{
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
    //CoreData Statistic
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    
    @objc private func managedObjectContextObjectsDidChange(notification: NSNotification){
        guard let userInfo = notification.userInfo else {return}
        didUpdateDatabase?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
            inserts.count > 0{
            print("Добавлено объектов: ", inserts.count)
        }
        
        if let update = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
           update.count > 0 {
            print("Обновлено объектов: ", update.count)
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
           deletes.count > 0 {
            print("Обновлено объектов: ", deletes.count)
        }
    }
    
    func bdStatistic() {
        self.mainContext.perform {
            do {
                let channel = try self.mainContext.count(for: DBChannel.fetchRequest())
                print("В базе -> \(channel) каналов")
                
                let messages = try self.mainContext.count(for: DBMessage.fetchRequest())
                print("В базе -> \(messages) сообщений")

            } catch let error{
                print("\(error.localizedDescription) в бд")
            }
        }
    }
}
