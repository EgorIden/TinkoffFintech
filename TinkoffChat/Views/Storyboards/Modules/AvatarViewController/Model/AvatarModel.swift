//
//  AvatarModel.swift
//  TinkoffChat
//
//  Created by Egor on 19/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
protocol IAvatarModel: class {
    var delegate: IAvatarModelDelegate? { get set }
    func fetch()
}
protocol IAvatarModelDelegate: class {
    func load(images: [Image])
}
class AvatarModel: IAvatarModel {
    weak var delegate: IAvatarModelDelegate?
    var imageService: IImageService
    init(imageService: IImageService) {
        self.imageService = imageService
    }
    func fetch() {
        imageService.getImagesURLs { (images, error) in
            if let images = images {
                self.delegate?.load(images: images)
                print("VC urls in model ->\(images.count)")
            }
        }
    }
}
