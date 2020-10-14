//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Egor on 14/10/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import Foundation

class GCDDataManager {
    
    let queue: DispatchQueue
    private let writeGroup = DispatchGroup()
    private let readGroup = DispatchGroup()
    private var errors: [Error] = []
    
    private let path: String = "/Users/egor/Desktop/xcode/Git/TinkoffFintech/"
    
    init (label: String = "some", qualityOfService: DispatchQoS = .userInitiated) {
      queue = DispatchQueue(label: "ru.tinkoff.TinkoffChat.\(label)", qos: qualityOfService, attributes: .concurrent)
    }
    
    func writeData(dataToSave: UserProfile, completion: @escaping (Bool)-> Void){
        
        saveDataToFile(data: dataToSave.name, filename: "name")
        saveDataToFile(data: dataToSave.info, filename: "info")
        
        if self.errors.isEmpty{
            completion(true)
        }else{
            completion(false)
        }
    }
    
    private func saveDataToFile(data: String, filename: String){
        
        queue.async(group: writeGroup, flags: .barrier) {[weak self] in
            guard let slf = self else{return}
            let filePath = "\(slf.path)\(filename).txt"
            do {
                try data.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
                print("Write to file")
            }
            catch let error {
                print(error.localizedDescription)
                self?.errors.append(error)
            }
        }
    }
    
    func uploadData(completion: @escaping (UserProfile?)-> Void){
        queue.async(group: readGroup){
            let user = UserProfile(name: self.readDataFromFile(filename: "name"),
                                    info: self.readDataFromFile(filename: "info"))
            DispatchQueue.main.async {
                if self.errors.isEmpty{
                    completion(user)
                }else{
                    completion(nil)
                }
            }
        }
    }
    
    private func readDataFromFile(filename: String) -> String {
        let filePath = "\(path)\(filename).txt"
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            print("Content of the file ''\(filename)'' is: \(content)")
            return content
        }
        catch let error {
            print(error.localizedDescription)
            self.errors.append(error)
        }
        return ""
    }
    
}
