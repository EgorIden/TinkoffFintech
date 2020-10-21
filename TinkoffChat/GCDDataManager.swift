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

    func writeData(dataToSave: UserProfile, completion: @escaping (Bool) -> Void) {

        //let userStringImg = saveImgToString(img: dataToSave.img)

        saveDataToFile(str: dataToSave.name, filename: "name")
        saveDataToFile(str: dataToSave.info, filename: "info")
        //saveDataToFile(str: userStringImg, filename: "img")
        saveImgToFile(img: dataToSave.img, filename: "img")

        if self.errors.isEmpty {
            completion(true)
        } else {
            completion(false)
        }
    }

    private func saveDataToFile(str: String, filename: String) {

        queue.async(group: writeGroup, flags: .barrier) {[weak self] in
            guard let slf = self else {return}
            let filePath = "\(slf.path)\(filename).txt"
            do {
                try str.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
                print("Write to file")
            } catch let error {
                print(error.localizedDescription)
                self?.errors.append(error)
            }
        }
    }

    func uploadData(completion: @escaping (UserProfile?) -> Void) {
        queue.async(group: readGroup) {

            //let baseStr = self.readDataFromFile(filename: "img")
            //guard let data = self.imgStringToData(imgStr: baseStr) else {return}
            //guard let data = self.imgData else{return}

            guard let dataImg = self.uploadImg(filename: "img") else {return}

            let user = UserProfile(name: self.readDataFromFile(filename: "name"),
                                    info: self.readDataFromFile(filename: "info"),
                                    img: UIImage(data: dataImg))

            DispatchQueue.main.async {
                if self.errors.isEmpty {
                    print("upload")
                    completion(user)
                } else {
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
        } catch let error {
            print(error.localizedDescription)
            self.errors.append(error)
        }
        return ""
    }

//    private func saveImgToString(img: UIImage?) -> String{
//
//        guard let image = img else{return ""}
//
//        if let pngData = image.pngData(){
//            self.imgData = pngData
//            let strData = String(decoding: pngData, as: UTF8.self)
//            return strData
//        }else{
//            guard let jpegData = image.jpegData(compressionQuality: 1.0) else{return ""}
//            self.imgData = jpegData
//            let strData = String(decoding: jpegData, as: UTF8.self)
//            return strData
//        }
//    }
//
//    private func imgStringToData(imgStr: String) -> Data?{
//        let dataStr = imgStr.data(using: String.Encoding.utf8)
//        return dataStr
//    }

    private func saveImgToFile(img: UIImage?, filename: String) {
        let pathURL = URL(string: "file://\(path)\(filename).txt")

        guard let url = pathURL else {return}
        guard let image = img else {return}

        if let pngData = image.pngData() {
            do {
                try pngData.write(to: url)
            } catch let error {
                print(error.localizedDescription)
                self.errors.append(error)
            }
        } else {
            guard let jpegData = image.jpegData(compressionQuality: 1.0) else {return}
            do {
                try jpegData.write(to: url)
            } catch let error {
                print(error.localizedDescription)
                self.errors.append(error)
            }
        }
    }

    private func uploadImg(filename: String) -> Data? {
        let pathURL = URL(string: "file://\(path)\(filename).txt")
        guard let url = pathURL else {return nil}

        do {
            let data = try Data.init(contentsOf: url)
            return data
        } catch let error {
            print(error.localizedDescription)
            self.errors.append(error)
            return nil
        }
    }

}
