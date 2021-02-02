//
//  FirebaseManager.swift
//  TinkoffChat
//
//  Created by Egor on 21/10/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import Firebase
protocol IFirebaseService {
    func addChannel(channel: Channel)
    func fetchChannels(completion: @escaping () -> Void)
    func fetchMessages(identifier: String, completion: @escaping () -> Void)
    func sendMessage(senderId: String, channelId: String, message: String)
    func deleteChannel(channelId: String)
}
class FirebaseManager: IFirebaseService {
    private lazy var database = Firestore.firestore()
    private lazy var channelsCollection = database.collection("channels")
    let coreDataService: ICoreDataService
    
    init(coreDataService: ICoreDataService) {
        self.coreDataService = coreDataService
    }
    
    // MARK: Add channel
    func addChannel(channel: Channel) {
        let channelInfo: [String: Any] = [
            "identifier": channel.identifier,
            "name": channel.name,
            "lastMessage": channel.lastMessage,
            "lastActivity": channel.lastActivity]
        channelsCollection.addDocument(data: channelInfo)
    }
    
    // MARK: Fetch channels
    func fetchChannels(completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let slf = self else { return }
            slf.channelsCollection.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
                let channels = documents.compactMap { (queryDocumentSnapshot) -> Channel? in
                    let data = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    guard let name = data["name"] as? String,
                        let lastMessage = data["lastMessage"] as? String,
                        let lastActivity = data["lastActivity"] as? Timestamp else {return nil}
                        let channel = Channel(identifier: id,
                                          name: name,
                                          lastMessage: lastMessage,
                                          lastActivity: lastActivity.dateValue())
                    return channel
                }
                print("count channels -> \(channels.count)")
                //add to coredata
                slf.coreDataService.saveChannels(channels: channels)
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    // MARK: Fetch messages
    func fetchMessages(identifier: String, completion: @escaping ()->Void) {
        DispatchQueue.global().async { [weak self] in
            guard let slf = self else{ return }
            let messageRef = slf.channelsCollection.document(identifier).collection("messages")
            messageRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
                let messages = documents.compactMap { (queryDocumentSnapshot) -> Message? in
                    let data = queryDocumentSnapshot.data()
                    guard let content = data["content"] as? String,
                        let created = data["created"] as? Timestamp,
                        let senderId = data["senderId"] as? String,
                        let senderName = data["senderName"] as? String else { return nil}
                    
                    let message = Message(content: content,
                                          created: created.dateValue(),
                                          senderId: senderId,
                                          senderName: senderName)
                    return message
                }
                print("Messages-> \(messages.count)")
                slf.coreDataService.saveMessages(identifier: identifier, messages: messages)
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    // MARK: Send messages
    func sendMessage(senderId: String, channelId: String, message: String) {
        let messageRef = self.channelsCollection.document(channelId).collection("messages")
        let time = Timestamp(date: Date())
        messageRef.addDocument(data: [
            "content": message,
            "created": time,
            "senderId": senderId,
            "senderName": "Mr. Orange"
        ])
    }
    // MARK: Delete channel
    func deleteChannel(channelId: String) {
        let channel = channelsCollection.document(channelId)
        channel.delete { error in
            if let error = error {
                print("Deleting channel error: \(error)")
            } else {
                self.coreDataService.deleteChannel(channelId: channelId)
            }
        }
    }
}
