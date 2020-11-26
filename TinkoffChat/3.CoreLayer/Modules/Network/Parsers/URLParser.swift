//
//  URLParser.swift
//  TinkoffChat
//
//  Created by Egor on 22/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
struct JSONModel: Codable {
    var hits: [Image]
}
struct Image: Codable {
    let userImageURL: String
}
class URLParser: IParser {
    typealias Model = [Image]
    let session = URLSession.shared
    // Parse JSON
    func parse(data: Data) -> Model? {
        do {
            let decoder = JSONDecoder()
            let images = try decoder.decode(JSONModel.self, from: data).hits
            return images
        } catch {
            print("Error converting data to JSON")
            return nil
        }
    }
}
