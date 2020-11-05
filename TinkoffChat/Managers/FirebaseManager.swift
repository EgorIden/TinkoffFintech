//
//  FirebaseManager.swift
//  TinkoffChat
//
//  Created by Egor on 21/10/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import Firebase

class FirebaseManager {
    private lazy var db = Firestore.firestore()
    private lazy var channelsCollection = db.collection("channels")
    
    // MARK: Add channel
    func addChannel(channel: Channel) {
        let channelInfo: [String: Any] = [
            "identifier": channel.identifier,
            "name": channel.name,
            "lastMessage": channel.lastMessage,
            "lastActivity": channel.lastActivity]
        channelsCollection.addDocument(data: channelInfo)
    }
    
    //text channesl
//    let testChannels: [Channel] = [
//        Channel(identifier: "23113212",
//                name: "Mr. White",
//                lastMessage: "Hello",
//                lastActivity: Timestamp.init(date: Date.init()).dateValue()),
//        Channel(identifier: "21212112",
//                name: "Mr. Orange",
//                lastMessage: "Hello",
//                lastActivity: Timestamp.init(date: Date.init()).dateValue()),
//        Channel(identifier: "565656",
//                name: "Mr. Blonde",
//                lastMessage: "Hello",
//                lastActivity: Timestamp.init(date: Date.init()).dateValue()),
//        Channel(identifier: "454545",
//                name: "Nice Guy",
//                lastMessage: "Hello",
//                lastActivity: Timestamp.init(date: Date.init()).dateValue()),
//        Channel(identifier: "95955",
//                name: "Nice Red",
//                lastMessage: "Hello",
//                lastActivity: Timestamp.init(date: Date.init()).dateValue())]
//
//    func fetchChannels(completion: @escaping () -> Void) {
//        DispatchQueue.global().async { [weak self] in
//            guard let slf = self else { return }
//            print("count channels -> \(slf.testChannels.count)")
//            //add to coredata
//            CoreDataManager.shared.saveChannelToDB(channels: slf.testChannels)
//            DispatchQueue.main.async {
//                    completion()
//                }
//            }
//        }
    
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
                CoreDataManager.shared.saveChannelToDB(channels: channels)
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    // MARK: Fetch messages
    func fetchMessages(id: String, completion: @escaping ()->Void) {
        DispatchQueue.global().async { [weak self] in
            guard let slf = self else{ return }
            let messageRef = slf.channelsCollection.document(id).collection("messages")
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
                CoreDataManager.shared.saveMessageToDB(id: id, messages: messages)
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
}
