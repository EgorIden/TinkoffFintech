//
//  AvatarModel.swift
//  TinkoffChat
//
//  Created by Egor on 23/11/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit
protocol IAvatarModel: class {
    var delegate: IAvatarModelDelegate? { get set }
    func fetchURL()
    func fetchImage(imageURL: String, completion: @escaping (UIImage?) -> Void)
}
protocol IAvatarModelDelegate: class {
    func loadURL(urls: [Image])
}
class AvatarModel: IAvatarModel {
    weak var delegate: IAvatarModelDelegate?
    var urlService: IURLService
    var imageService: IImageService
    init(urlService: IURLService, imageService: IImageService) {
        self.urlService = urlService
        self.imageService = imageService
    }
    func fetchURL() {
        self.urlService.loadURL { [weak self] (urls, error) in
            guard let slf = self else { return }
            if let urls = urls {
                slf.delegate?.loadURL(urls: urls)
                print("VC urls in model ->\(urls.count)")
            } else if let error = error {
                print("Error in loadURL -> \(error)")
            }
        }
    }
    func fetchImage(imageURL: String, completion: @escaping (UIImage?) -> Void) {
        self.imageService.loadImage(imageURL: imageURL) { (image, error) in
            if let image = image {
                completion(image)
                print("VC image in model ->\(image)")
            } else if let error = error {
                print("Error in loadURL -> \(error)")
                return
            }
        }
    }
}
