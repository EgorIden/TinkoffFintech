//
//  ImageParser.swift
//  TinkoffChat
//
//  Created by Egor on 22/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit
class ImageParser: IParser {
    typealias Model = UIImage
    let session = URLSession.shared
    // Parse JSON
    func parse(data: Data) -> Model? {
        guard let image = UIImage(data: data) else { return nil }
        return image
    }
}
