//
//  UserProfile.swift
//  TinkoffChat
//
//  Created by Egor on 13/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

struct UserProfile {
    var name: String
    var info: String
    var img: UIImage?
    init(name: String, info: String, imgName: String) {
        self.name = name
        self.info = info
        self.img = UIImage(named: imgName)
    }
    init(name: String, info: String, img: UIImage?) {
        self.name = name
        self.info = info
        self.img = img
    }
}
