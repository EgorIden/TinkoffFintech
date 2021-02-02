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
    
    func addChannel(channel: Channel){
        var channelInfo: [String: Any] = [
            "identifier": channel.identifier,
            "name": channel.name,
            "lastMessage": channel.lastMessage,
            "lastActivity": channel.lastActivity]
        
        channelsCollection.addDocument(data: channelInfo)
    }
    
    func fetchChannels(completion: @escaping ([Channel]) -> Void){
        DispatchQueue.global().async { [weak self] in
            guard let slf = self else{return}
            slf.channelsCollection.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                print("no documents")
                return
            }
                let channels = documents.map { (queryDocumentSnapshot) -> Channel in
                    let data = queryDocumentSnapshot.data()
                    
                    let id = queryDocumentSnapshot.documentID
                    let name = data["name"] as? String ?? ""
                    let lastMessage = data["lastMessage"] as? String
                    let lastActivity = data["lastActivity"] as? Timestamp
                    
                    let channel = Channel(identifier: id,
                                          name: name,
                                          lastMessage: lastMessage,
                                          lastActivity: lastActivity?.dateValue())
                    return channel
                }
                print("count \(channels.count)")
                let filtredChannels = channels.filter { $0.identifier != "" && $0.name != ""}
                print("filter \(filtredChannels.count)")
                DispatchQueue.main.async {
                    completion(filtredChannels)
                }
            }
        }
    }
    
    func fetchMessages(id: String, completion: @escaping ([Message])->Void){
        DispatchQueue.global().async { [weak self] in
            guard let slf = self else{return}
            let messageRef = slf.channelsCollection.document(id).collection("messages")
            messageRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                print("no documents")
                return
            }
                
                
                let messages = documents.map { (queryDocumentSnapshot) -> Message in
                    let data = queryDocumentSnapshot.data()
                    
                    let content = data["content"] as? String
                    let created = data["created"] as? Timestamp
                    let senderId = data["senderId"] as? String
                    let senderName = data["senderName"] as? String
                    
                    let message = Message(content: content ?? "",
                                          created: created?.dateValue() ?? Timestamp.init(date: Date(timeIntervalSince1970: 0)).dateValue(),
                                          senderId: senderId ?? "No ID",
                                          senderName: senderName ?? "No name")
                    return message
                }
                DispatchQueue.main.async {
                    completion(messages)
                }
            }
        }
    }

}
