//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Egor on 15/10/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

class OperationDataManager: Operation {

    var inputData: String
    var fileName: String
    var output: String?
    var changedFlag: Bool

    private let path: String = "/Users/egor/Desktop/xcode/Git/TinkoffFintech/"
    
    init(inputData:String, fileName:String, changedFlag: Bool){
        self.inputData = inputData
        self.fileName = fileName
        self.changedFlag = changedFlag
    }

    override func main() {
        save()
        output = upload()
    }

    func save() {
        if changedFlag {
            saveDataToFile(data: inputData, filename: fileName)
        }
    }

    func upload() -> String{
        return readDataFromFile(filename: fileName) ?? ""
    }
    
    private func saveDataToFile(data: String, filename: String){
        let filePath = "\(path)\(filename).txt"
        do {
            try data.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
            print("Write to file")
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func readDataFromFile(filename: String) -> String? {
        let filePath = "\(path)\(filename).txt"
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            print("Content of the file ''\(filename)'' is: \(content)")
            return content
        }
        catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
}
